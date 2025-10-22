# ROS 2 Config

System config for ROS 2 packages.

Note: This is a public, stripped-down version of a private repository. It may depend on other repositories which might not have a public version. Some paths, configurations, dependencies, have been removed or altered, so the code may not run out of the box.

For configuration of ROS and custom packages, we use bash environment variables.
Additionally this repository contains scripts for the following purposes:

- [Set the system's UDP buffer size](scripts/set_udp_buffer_size.sh)
- [Setup the ROS Middleware (RMW)](scripts/setup_rmw.sh)
- [Restart all running containers](scripts/restart_containers.sh)

## Setup

Check [envs](envs) if there is a RMW config matching to your hostname. Also check [cyclonedds](cyclonedds).

### Global instance

Setup one global instance of this repository at the desired path. This allows configuration of the entire system by changing only the global config:

```bash
cd path_desired_parent
git clone https://github.com/bertan-karacora/ros2_config.git
```

Add the path to your environment:

```bash
PATH_ROS2_CONFIG_GLOBAL="path_desired_parent/ros2_config"
echo "export PATH_ROS2_CONFIG_GLOBAL=\"$PATH_ROS2_CONFIG_GLOBAL\"" >> ~/.bashrc
```

Setup the ROS 2 middleware once:

```bash
scripts/setup_rmw.sh
```

### Local instances

Setup a local instance in your projects to keep encapsulation:

```bash
cd path_to_project
mkdir libs
git submodule add https://github.com/bertan-karacora/ros2_config libs/ros2_config
```

If you use containers, make sure to overlay the local config by mounting the global config if available.

## Usage

### Set UDP buffer size

The default UDP buffer in Ubuntu systems too small to transport large chunks of data in real-time, e.g., camera images.
If you encounter issues related to the size of ROS messages, check this setting.
Set the UDP buffer size using the designated [script](scripts/set_udp_buffer_size.sh).

```bash
scripts/set_udp_buffer_size.sh --use_permanent
```

### Apply configs

Apply a config using

```bash
cd path_to_ros2_config
source /env.sh
```

In your local projects, e.g., a script in `path_to_project/scripts`, you may use something like this:

```bash
readonly path_repo="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
source "$path_repo/libs/ros2_config/env.sh"
```

### Apply updates to containers

For config changes to take effect in running containers you need to restart them (note that the default arguments for running these containers are used):

```bash
cd path_to_ros2_config_global
scripts/restart_containers.sh
```
