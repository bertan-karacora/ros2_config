#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
source "$path_repo/env.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup_rmw.sh [-h | --help]"
    echo
    echo "Setup the ROS 2 middleware."
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
        *)
            echo "Unknown option $arg"
            exit 1
            ;;
        esac
    done
}

setup_rmw() {
    name_host="$(hostname)"

    mkdir --parents "$HOME/.ros"

    echo "Setting up ROS 2 middleware finished"
}

main() {
    parse_args "$@"
    setup_rmw
}

main "$@"
