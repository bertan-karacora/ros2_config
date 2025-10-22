path_ros2_config_local="$(dirname "$(realpath "$BASH_SOURCE")")"
name_host="$(hostname)"
filename_env="env_$name_host.sh"

if [[ -v PATH_ROS2_CONFIG_GLOBAL ]] && [[ ! -z "$PATH_ROS2_CONFIG_GLOBAL" ]]; then
    if [[ -f "$PATH_ROS2_CONFIG_GLOBAL/envs/$filename_env" ]]; then
        source "$PATH_ROS2_CONFIG_GLOBAL/envs/$filename_env"
        echo "Sourced $filename_env from global config at $PATH_ROS2_CONFIG_GLOBAL/envs"
    elif [[ -f "$path_ros2_config_local/envs/$filename_env" ]]; then
        source "$path_ros2_config_local/envs/$filename_env"
        echo "Sourced $filename_env from local config at $path_ros2_config_local/envs"
    else
        echo "$filename_env not found in either global or local config paths"
    fi
else
    echo "PATH_ROS2_CONFIG_GLOBAL is undefined or empty."
    if [[ -f "$path_ros2_config_local/envs/$filename_env" ]]; then
        source "$path_ros2_config_local/envs/$filename_env"
        echo "Sourced $filename_env from local config at $path_ros2_config_local/envs"
    else
        echo "$filename_env not found in either global or local config paths"
    fi
fi

unset path_ros2_config_local
unset name_host
unset filename_env
