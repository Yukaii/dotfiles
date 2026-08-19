#!/usr/bin/env bash

toggle_kasa_plug() {
  local light_name=$1
  local ip_variable=$2
  local helper_dir
  local repo_root
  local env_file
  local inherited_username=${KASA_USERNAME:-}
  local inherited_password=${KASA_PASSWORD:-}
  local inherited_ip=${!ip_variable:-}
  local uvx_bin
  local kasa_source
  local plug_ip
  local output

  helper_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  repo_root=$(cd "$helper_dir/../../.." && pwd)
  env_file=${KASA_ENV_FILE:-"$repo_root/.storage/kasa.env"}

  if [[ -r "$env_file" ]]; then
    # Export assignments from the private config for the kasa subprocess.
    set -a
    # shellcheck disable=SC1090
    source "$env_file"
    set +a
  fi

  # Explicit process variables take precedence over the config file.
  [[ -n "$inherited_username" ]] && KASA_USERNAME=$inherited_username
  [[ -n "$inherited_password" ]] && KASA_PASSWORD=$inherited_password
  [[ -n "$inherited_ip" ]] && printf -v "$ip_variable" '%s' "$inherited_ip"

  uvx_bin=${UVX_BIN:-}
  kasa_source=${KASA_PACKAGE_SOURCE:-git+https://github.com/ZeliardM/python-kasa@71a4147984aedc7cfa9ce4613204ecf28b15dac7}
  plug_ip=${!ip_variable:-}

  if [[ -z "$plug_ip" ]]; then
    echo "Set $ip_variable in $env_file"
    return 1
  fi

  if [[ -z "${KASA_USERNAME:-}" || -z "${KASA_PASSWORD:-}" ]]; then
    echo "Set KASA_USERNAME and KASA_PASSWORD in $env_file"
    return 1
  fi

  if [[ -z "$uvx_bin" ]]; then
    if [[ -x /opt/homebrew/bin/uvx ]]; then
      uvx_bin=/opt/homebrew/bin/uvx
    elif [[ -x /usr/local/bin/uvx ]]; then
      uvx_bin=/usr/local/bin/uvx
    elif command -v uvx >/dev/null 2>&1; then
      uvx_bin=$(command -v uvx)
    else
      echo "uvx is unavailable; install uv with Homebrew"
      return 1
    fi
  fi

  if ! output=$("$uvx_bin" --from "$kasa_source" kasa --host "$plug_ip" toggle 2>&1); then
    printf '%s\n' "$output" >&2
    echo "Failed to toggle $light_name"
    return 1
  fi

  echo "$light_name toggled"
}
