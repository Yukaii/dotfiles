
function __fish_nix_completions_dissect_short_long
    if test (string sub -s 3 -l 2 -- $argv) = --
        echo (string sub -s 1 -l 2 -- $argv)
        echo (string sub -s 3 -- $argv)
        return 0
    end
    return 1
end

function __fish_nix_completions_get_token_list
    set cmd (commandline -opc)
    set -e cmd[1]
    for token in $cmd
        if test (string sub -l 1 -- $token) = -
        and test (string sub -s 2 -l 1 -- $token) != -
            for chr in (string split "" -- (string sub -s 2 -- $token))
                echo -$chr
            end
        else
            echo $token
        end
    end
end

function __fish_nix_completions_print_current_top
    function __fish_nix_completions_pda_step --argument token --no-scope-shadowing
        if not set -q stack[1]
            return 1
        end
        for rule in $rule_list
            set rule (string split ":" -- $rule)
            if contains -- $rule[1] PLACEHOLDER $stack[1]
                set dissect (__fish_nix_completions_dissect_short_long $rule[2])
                if begin
                    not test -n "$dissect"; and contains -- $rule[2] PLACEHOLDER $token
                end; or begin
                    test -n "$dissect"; and contains -- $token $dissect[1] $dissect[2]
                end
                    set -e rule[1]
                    set -e rule[1]
                    set -e stack[1]
                    set stack $rule $stack
                    return 0
                end
            end
        end
        return 1
    end

    function __fish_nix_completions_pda_calc --no-scope-shadowing
        for token in $token_list
            __fish_nix_completions_pda_step $token
            if test $status -ne 0
                return 1
            end
        end
    end

    function __fish_nix_completions_pda_calc_and_print_top --no-scope-shadowing
        __fish_nix_completions_pda_calc
        if test $status -ne 0
        or not set -q stack[1]
            echo ERROR
        else
            echo $stack[1]
        end
    end

    set stack 1
    set token_list (__fish_nix_completions_get_token_list)
    set rule_list $argv

    __fish_nix_completions_pda_calc_and_print_top
end

function __fish_nix_completions_current_top_is --argument state
    set -e argv[1]
    set output (__fish_nix_completions_print_current_top $argv)
    test $output = $state
end

function __fish_nix_completions_current_top_is_not_fd
    set output (__fish_nix_completions_print_current_top $argv)
    not contains $output File Dir FD
end

function __fish_nix_completions_normalize_rule_list
    set argv (string trim $argv)
    set argv (string replace --all \t " " -- $argv)
    set argv (string replace --all \n " " -- $argv)
    set argv (string replace --all --regex "\ *:\ *" ":" -- $argv) # colon
    set argv (string replace --all --regex "\ *;\ *" ";" -- $argv) # semicolon
    for rule in $argv
        test -n "$rule"; or continue
        echo $rule
    end
end

# Takes normalized rules with descriptions and prints them without descriptions, and escaped
function __fish_nix_completions_escaped_pda_rule_list
    for rule in $argv
        set split (string split --max 1 ";" -- $rule)
        string escape $split[1]
    end
end

function __fish_nix_completions_create_completions --argument cmd
    set -e argv[1]
    set rule_list (__fish_nix_completions_normalize_rule_list $argv)
    complete --erase -c $cmd
    set escaped_rules (__fish_nix_completions_escaped_pda_rule_list $rule_list)
    for rule in $rule_list
        set description (string split --max 1 ";" -- $rule)
        set rule (string split --max 2 ":" -- $description[1])
        set -e description[1]
        set top $rule[1]
        set token $rule[2]
        if test PLACEHOLDER != $token
            set dissect (__fish_nix_completions_dissect_short_long $token)
            if test -n "$dissect"
                for i in 1 2
                    complete -x -c $cmd -n "__fish_nix_completions_current_top_is $top $escaped_rules" \
                        -a $dissect[$i] -d "$description"
                end
            else
                complete -c $cmd -n "__fish_nix_completions_current_top_is $top $escaped_rules" -a $token -d "$description"
            end
        end
    end
    complete -f -c $cmd -n "__fish_nix_completions_current_top_is_not_fd $escaped_rules"
end

function __fish_nix_completions_shared_rules
    echo "
    1: --help                       ; Print command reference
    1: --version                    ; Print Nix version
    1: --no-build-output: 1         ; Suppress build output
    1: -k--keep-going: 1            ; Continue building in case of failed builds
    1: -K--keep-failed: 1           ; Keep the temporary directory on build failure
    1: --fallback: 1                ; If substituting fail, build from source
    1: --no-build-hook: 1           ; Disable the build hook mechanism
    1: --readonly-mode: 1           ; Forbid opening of the Nix database
    1: --repair: 1                  ; Fix corrupted or missing store paths
    1: -v--verbose: Int: 1          ; Set verbosity level of standard error output
    1: -j--max-jobs: Int: 1         ; Set maximum number of parallel jobs
    1: --cores: Int: 1              ; Set NIX_BUILD_CORES
    1: --max-silent-time: Int: 1    ; Set builder timeout after output
    1: --timeout: Int: 1            ; Set absolute builder timeout
    1: --option: String: String: 1  ; Set a nix configuration option
    File: PLACEHOLDER
    Dir: PLACEHOLDER
    FD: PLACEHOLDER
    Expr: PLACEHOLDER
    Int: PLACEHOLDER
    String: PLACEHOLDER
    VariadicInts: PLACEHOLDER: VariadicInts
    VariadiceStrings: PLACEHOLDER: VariadiceStrings
    VariadicePkgs: PLACEHOLDER: VariadicePkgs
    "
end

function __fish_nix_completions_arg_rules
    echo "
    1: --arg: String: String: 1     ; Pass name-value pair to the function evaluator
    1: --argstr: String: String: 1  ; Pass name-string pair to the function evaluator
    "
end

# TODO: When we do package completion, how do we do it for --install and --upgrade?
function __fish_nix_completions_rules_nix_env
    echo "
    1: --dry-run: 1                 ; Print what would be done, without doing it
    1: -f--file: FD: 1              ; Specify Nix expression from file or URL
    1: -p--profile: FD: 1           ; Specify profile
    1: --system-filter: String: 1   ; TODO: system-filter
    1: -i--install: install         ; Install packages into the current profile
    install: -b--prebuild-only: install         ; Don't build, use only pre-built binaries
    install: -P--preserve-installed: install    ; Don't remove matching derivations
    install: -r--remove-all: install            ; Remove all installed packages first
    install: PLACEHOLDER: install
    1: -u--upgrade: upgrade         ; Upgrade packages in the current profile
    upgrade: --lt: upgrade          ; Only update to newer version (default)
    upgrade: --leq: upgrade         ; Upgrade to newer or same versions
    upgrade: --eq: upgrade          ; Only upgrade to same versions
    upgrade: --always: upgrade      ; Upgrade even if the version will be lower
    1: -e--uninstall: VariadicPkgs  ; Remove packages from the current profile
    1: --set: VariadicPkgs          ; Remove all packages except for the specified
    1: --set-flag: String: String: VariadicPkgs ; Set meta attributes of specified packages
    1: -q--query: query             ; Info about installed or available packages
    query: --installed: query       ; Query operates on installed store paths
    query: -a--available: query     ; Query operates on available store paths
    query: --xml: query             ; Print result as XML
    query: --json: query            ; Print resut as JSON
    query: -b--prebuilt-only: query ; Only derivations for which a substitute is registered
    query: -s--status: query        ; Print the status of the derivations
    query: -P--attr-path: query     ; Print the attribute path of the derivation
    query: --no-name: query         ; Don't print the name of the derivation
    query: -c--compare-versions: query          ; Compare installed to available versions
    query: --system: query          ; Print the system attribute of the derivation
    query: --drv-path: query        ; Print the path of the store derivation
    query: --out-path: query        ; Print the output path of the derivation
    query: --description: query     ; Print a short description of the derivation
    query: --meta: query            ; Print all meta-attributes of the derivation
    1: -S--switch-profile: Dir      ; Switch to a different profile
    1: --delete-generations: dgen   ; Delete generations of the current profile
    dgen: old                       ; Delete all non-current generations
    dgen: 7d                        ; Delete generations that are older than 7 days
    dgen: 30d                       ; Delete generations that are older than 30 days
    dgen: PLACEHOLDER: VariadicInts
    1: -G--switch-generation: Int   ; Switch to a different gen. of the current profile
    1: --rollback                   ; Switch to the previous gen. of the current profile
    "
end

__fish_nix_completions_create_completions nix-env \
    (__fish_nix_completions_shared_rules) \
    (__fish_nix_completions_arg_rules) \
    (__fish_nix_completions_rules_nix_env)

__fish_nix_completions_create_completions nix-build \
    (__fish_nix_completions_arg_rules) \
    (__fish_nix_completions_shared_rules)

__fish_nix_completions_create_completions nix-store \
    (__fish_nix_completions_arg_rules) \
    (__fish_nix_completions_shared_rules)
