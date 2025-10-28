#!/usr/bin/env bash
# Test suite for git-rewrite-commit-times
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/git-rewrite-commit-times"
TEST_DIR=$(mktemp -d)
TESTS_PASSED=0
TESTS_FAILED=0

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

log_test() {
    echo -e "${BLUE}[TEST]${NC} $*"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $*"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $*"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $*"
}

# Create a test repository with N commits at specified times
create_test_repo() {
    local repo_name=$1
    shift
    local repo_path="$TEST_DIR/$repo_name"

    mkdir -p "$repo_path"
    cd "$repo_path"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"

    local commit_num=1
    while [ $# -gt 0 ]; do
        local commit_time=$1
        echo "Content $commit_num" > "file$commit_num.txt"
        git add .
        env GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" \
            git commit -q -m "Commit $commit_num"
        commit_num=$((commit_num + 1))
        shift
    done
}

# Test 1: Verify all commits are processed (the bug we just fixed)
test_all_commits_processed() {
    log_test "Test 1: All commits are processed"

    create_test_repo "test1" \
        "2024-10-21 10:00:00" \
        "2024-10-21 11:00:00" \
        "2024-10-21 12:00:00"

    cd "$TEST_DIR/test1"
    local original_count=$(git log --oneline | wc -l | tr -d ' ')

    # Run dry-run and capture output
    local output=$(echo "n" | "$SCRIPT_PATH" --dry-run 2>&1)

    # Extract the "Processing N commits" line (strip ANSI codes first)
    local processed_count=$(echo "$output" | sed 's/\x1b\[[0-9;]*m//g' | grep "Processing" | grep -oE '[0-9]+' | head -1)

    if [ "$original_count" = "$processed_count" ]; then
        log_pass "All $original_count commits were processed"
    else
        log_fail "Expected $original_count commits, but only $processed_count were processed"
    fi
}

# Test 2: Work hours are correctly identified
test_work_hours_detection() {
    log_test "Test 2: Work hours detection"

    create_test_repo "test2" "2024-10-21 14:00:00"
    cd "$TEST_DIR/test2"

    local output=$(echo "y" | "$SCRIPT_PATH" 2>&1)

    # The commit at 14:00 (work hours) should be moved to non-work hours
    local new_time=$(git log --pretty=format:"%ai" -n 1)
    local new_hour=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$new_time" "+%H" 2>/dev/null)
    new_hour=$((10#$new_hour))

    # Check if it's now in non-work hours (before 8 or after 18)
    if [ $new_hour -lt 8 ] || [ $new_hour -ge 18 ]; then
        log_pass "Commit moved from work hours to non-work hours (hour: $new_hour)"
    else
        log_fail "Commit still in work hours (hour: $new_hour)"
    fi
}

# Test 3: Weekend-only mode
test_weekend_only_mode() {
    log_test "Test 3: Weekend-only mode"

    create_test_repo "test3" \
        "2024-10-21 10:00:00" \
        "2024-10-22 11:00:00"

    cd "$TEST_DIR/test3"
    echo "y" | "$SCRIPT_PATH" --weekend-only >/dev/null 2>&1

    local all_weekend=true
    while read -r commit_date; do
        local day_of_week=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%w" 2>/dev/null)
        if [ "$day_of_week" != "0" ] && [ "$day_of_week" != "6" ]; then
            all_weekend=false
            break
        fi
    done < <(git log --pretty=format:"%ai")

    if [ "$all_weekend" = true ]; then
        log_pass "All commits moved to weekends"
    else
        log_fail "Some commits are not on weekends"
    fi
}

# Test 4: Dry-run doesn't modify repository
test_dry_run_no_modification() {
    log_test "Test 4: Dry-run doesn't modify repository"

    create_test_repo "test4" "2024-10-21 10:00:00"
    cd "$TEST_DIR/test4"

    local original_hash=$(git rev-parse HEAD)
    local original_time=$(git log --pretty=format:"%ai" -n 1)

    "$SCRIPT_PATH" --dry-run >/dev/null 2>&1

    local new_hash=$(git rev-parse HEAD)
    local new_time=$(git log --pretty=format:"%ai" -n 1)

    if [ "$original_hash" = "$new_hash" ] && [ "$original_time" = "$new_time" ]; then
        log_pass "Dry-run did not modify repository"
    else
        log_fail "Dry-run modified the repository"
    fi
}

# Test 5: Backup branch is created
test_backup_branch_created() {
    log_test "Test 5: Backup branch is created"

    create_test_repo "test5" "2024-10-21 10:00:00"
    cd "$TEST_DIR/test5"

    echo "y" | "$SCRIPT_PATH" >/dev/null 2>&1

    local backup_branches=$(git branch | grep "backup-" | wc -l | tr -d ' ')

    if [ "$backup_branches" -gt 0 ]; then
        log_pass "Backup branch was created"
    else
        log_fail "No backup branch was created"
    fi
}

# Test 6: Time intervals are realistic based on changeset size
test_realistic_time_intervals() {
    log_test "Test 6: Realistic time intervals based on changeset size"

    create_test_repo "test6" "2024-10-21 10:00:00"
    cd "$TEST_DIR/test6"

    # Add a commit with many lines
    for i in {1..200}; do
        echo "Line $i" >> large_file.txt
    done
    git add .
    env GIT_AUTHOR_DATE="2024-10-21 11:00:00" GIT_COMMITTER_DATE="2024-10-21 11:00:00" \
        git commit -q -m "Large commit"

    echo "y" | "$SCRIPT_PATH" >/dev/null 2>&1

    # Get timestamps of the two commits
    local timestamps=($(git log --pretty=format:"%at" --reverse))
    local time_diff=$((timestamps[1] - timestamps[0]))

    # For 200 lines, we expect roughly 2 hours = 7200 seconds, but with variance
    # Let's check if it's at least 30 minutes (1800s) apart
    if [ $time_diff -gt 1800 ]; then
        log_pass "Time interval is realistic ($time_diff seconds for large changeset)"
    else
        log_fail "Time interval too short ($time_diff seconds)"
    fi
}

# Test 7: Commits maintain chronological order
test_chronological_order() {
    log_test "Test 7: Commits maintain chronological order"

    create_test_repo "test7" \
        "2024-10-21 10:00:00" \
        "2024-10-21 11:00:00" \
        "2024-10-21 12:00:00"

    cd "$TEST_DIR/test7"
    echo "y" | "$SCRIPT_PATH" >/dev/null 2>&1

    local timestamps=($(git log --pretty=format:"%at" --reverse))
    local in_order=true

    for ((i=1; i<${#timestamps[@]}; i++)); do
        if [ ${timestamps[i]} -le ${timestamps[i-1]} ]; then
            in_order=false
            break
        fi
    done

    if [ "$in_order" = true ]; then
        log_pass "Commits maintain chronological order"
    else
        log_fail "Commits are not in chronological order"
    fi
}

# Test 8: Evening-only mode
test_evening_only_mode() {
    log_test "Test 8: Evening-only mode (18:00-23:59)"

    create_test_repo "test8" "2024-10-21 10:00:00"
    cd "$TEST_DIR/test8"

    echo "y" | "$SCRIPT_PATH" --evening-only >/dev/null 2>&1

    local all_evening=true
    while read -r commit_date; do
        local hour=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%H" 2>/dev/null)
        hour=$((10#$hour))
        local day_of_week=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%w" 2>/dev/null)

        # Should be weekday (1-5) and evening hours (18-23)
        if [ "$day_of_week" -ge 1 ] && [ "$day_of_week" -le 5 ]; then
            if [ $hour -lt 18 ] || [ $hour -ge 24 ]; then
                all_evening=false
                break
            fi
        else
            all_evening=false
            break
        fi
    done < <(git log --pretty=format:"%ai")

    if [ "$all_evening" = true ]; then
        log_pass "All commits in evening hours on weekdays"
    else
        log_fail "Some commits not in evening hours"
    fi
}

# Test 9: Night-only mode
test_night_only_mode() {
    log_test "Test 9: Night-only mode (00:00-08:00)"

    create_test_repo "test9" "2024-10-21 14:00:00"
    cd "$TEST_DIR/test9"

    echo "y" | "$SCRIPT_PATH" --night-only >/dev/null 2>&1

    local all_night=true
    while read -r commit_date; do
        local hour=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%H" 2>/dev/null)
        hour=$((10#$hour))
        local day_of_week=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%w" 2>/dev/null)

        # Should be weekday (1-5) and night hours (0-7)
        if [ "$day_of_week" -ge 1 ] && [ "$day_of_week" -le 5 ]; then
            if [ $hour -ge 8 ]; then
                all_night=false
                break
            fi
        else
            all_night=false
            break
        fi
    done < <(git log --pretty=format:"%ai")

    if [ "$all_night" = true ]; then
        log_pass "All commits in night hours on weekdays"
    else
        log_fail "Some commits not in night hours"
    fi
}

# Test 10: Workday-only mode
test_workday_only_mode() {
    log_test "Test 10: Workday-only mode (08:00-18:00 weekdays)"

    create_test_repo "test10" \
        "2024-10-26 14:00:00" \
        "2024-10-27 02:00:00"

    cd "$TEST_DIR/test10"
    echo "y" | "$SCRIPT_PATH" --workday-only >/dev/null 2>&1

    local all_workday=true
    while read -r commit_date; do
        local hour=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%H" 2>/dev/null)
        hour=$((10#$hour))
        local day_of_week=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$commit_date" "+%w" 2>/dev/null)

        # Should be weekday (1-5) and work hours (8-17)
        if [ "$day_of_week" -ge 1 ] && [ "$day_of_week" -le 5 ]; then
            if [ $hour -lt 8 ] || [ $hour -ge 18 ]; then
                all_workday=false
                break
            fi
        else
            all_workday=false
            break
        fi
    done < <(git log --pretty=format:"%ai")

    if [ "$all_workday" = true ]; then
        log_pass "All commits in workday hours on weekdays"
    else
        log_fail "Some commits not in workday hours"
    fi
}

# Test 11: Custom start date
test_custom_start_date() {
    log_test "Test 11: Custom start date"

    create_test_repo "test11" "2024-10-21 10:00:00"
    cd "$TEST_DIR/test11"

    echo "y" | "$SCRIPT_PATH" -s "2024-11-01 20:00:00" >/dev/null 2>&1

    local commit_date=$(git log --pretty=format:"%ai" -n 1 | cut -d' ' -f1)

    # Commit should be on or after 2024-11-01
    if [[ "$commit_date" > "2024-11-01" ]] || [[ "$commit_date" == "2024-11-01" ]]; then
        log_pass "Custom start date respected (commit on $commit_date)"
    else
        log_fail "Custom start date not respected (commit on $commit_date)"
    fi
}

# Run all tests
main() {
    echo "=========================================="
    echo "Git Rewrite Commit Times - Test Suite"
    echo "=========================================="
    echo
    log_info "Script: $SCRIPT_PATH"
    log_info "Test directory: $TEST_DIR"
    echo

    test_all_commits_processed
    test_work_hours_detection
    test_weekend_only_mode
    test_dry_run_no_modification
    test_backup_branch_created
    test_realistic_time_intervals
    test_chronological_order
    test_evening_only_mode
    test_night_only_mode
    test_workday_only_mode
    test_custom_start_date

    echo
    echo "=========================================="
    echo "Test Results"
    echo "=========================================="
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo

    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

main "$@"
