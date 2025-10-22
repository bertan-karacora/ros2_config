#!/usr/bin/env bash

set -euo pipefail

readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
source "$path_repo/env.sh"

# Elements of names_container and paths_repo need to correspond to each other
readonly names_container=("$NAME_CONTAINER_ROS2_ORBBEC_LAUNCH" "$NAME_CONTAINER_ROS2_CAMERA_IDS" "$NAME_CONTAINER_ROS2_PERSON_DETECTION_2D_LIDAR" "$NAME_CONTAINER_ROS2_PERSON_TRACKING")
readonly paths_repo=("$PATH_ROS2_ORBBEC_LAUNCH" "$PATH_ROS2_CAMERA_IDS" "$PATH_ROS2_PERSON_DETECTION_2D_LIDAR" "$PATH_ROS2_PERSON_TRACKING")

show_help() {
    echo "Usage:"
    echo "  ./restart_containers.sh [-h | --help]"
    echo
    echo "Restart all containers."
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

is_running_container() {
    local name_container="$1"

    local id_container="$(docker ps --quiet --filter "name=^/$name_container$")"
    if [[ "$id_container" ]]; then
        return 0
    else
        return 1
    fi
}

is_found_container() {
    local name_container="$1"

    local id_container="$(docker ps --quiet --all --filter "name=^/$name_container$")"
    if [[ "$id_container" ]]; then
        return 0
    else
        return 1
    fi
}

stop_containers() {
    for name_container in "${names_container[@]}"; do
        if is_running_container "$name_container"; then
            echo "Stopping container $name_container ..."
            docker stop "$name_container" >/dev/null 2>&1 &
        else
            echo "Container $name_container not running"
        fi
    done
    wait
}

remove_containers() {
    for name_container in "${names_container[@]}"; do
        if is_found_container "$name_container"; then
            echo "Removing container $name_container ..."
            docker rm "$name_container" >/dev/null 2>&1 &
        else
            echo "Container $name_container not found"
        fi
    done
    wait
}

start_containers() {
    for i in "${!paths_repo[@]}"; do
        local path_script_run="${paths_repo[$i]}/container/run.sh"
        local name_container="${names_container[$i]}"
        if [[ -x "$path_script_run" ]]; then
            echo "Starting container $name_container ..."
            "$path_script_run"
        else
            echo "Script at $path_script_run is not executable"
        fi
    done
    wait
}

main() {
    parse_args "$@"
    stop_containers
    remove_containers
    start_containers
}

main "$@"
