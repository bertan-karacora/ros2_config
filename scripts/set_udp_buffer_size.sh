#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"

size_buffer=2147483647
use_permanent=""

show_help() {
    echo "Usage:"
    echo "  ./set_udp_buffer_size.sh [-h | --help] [--size_buffer <value>] [--use_permanent]"
    echo
    echo "Set the UDP buffer size."
    echo
}

parse_args() {
    local arg=""
    while [[ "$#" -gt 0 ]]; do
        arg="$1"
        shift
        case "$arg" in
        -h | --help)
            show_help
            exit 0
            ;;
        --size_buffer)
            size_buffer="$1"
            shift

            if [[ -z "$size_buffer" || "$size_buffer" -ne "$size_buffer" ]]; then
                echo "Please provide a number as size in MB"
                exit 1
            fi
            ;;
        --use_permanent)
            use_permanent=1
            ;;
        *)
            echo "Unknown option $arg"
            exit 1
            ;;
        esac
    done
}

check_user_is_root() {
    if [[ "$(whoami)" != "root" ]]; then
        echo Please run this script as root
        exit 1
    fi
}

set_udp_buffer_size() {
    sysctl --write "net.core.rmem_max=$size_buffer" >/dev/null
    sysctl --write "net.core.rmem_default=$size_buffer" >/dev/null

    echo "UDP buffer size set to $size_buffer"
}

set_udp_buffer_size_permanent() {
    set_udp_buffer_size

    local path_sysconf="/etc/sysctl.d/10-cyclone-max.conf"
    export SIZE_BUFFER="$size_buffer"
    cat "$path_repo/resources/10-cyclone-max.conf.template" | envsubst >"$path_sysconf"
    unset SIZE_BUFFER

    echo "UDP buffer size permanently added to $path_sysconf"
}

main() {
    parse_args "$@"
    check_user_is_root
    if [[ ! -z "$use_permanent" ]]; then
        set_udp_buffer_size_permanent
    else
        set_udp_buffer_size
    fi
}

main "$@"
