set -a

# ROS env
ROS_DOMAIN_ID=42

# ROS middleware
RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI="$HOME/.ros/cyclonedds.example.xml"

# Paths
PATH_MAPS="$HOME/data/maps"
PATH_ROS2_CAMERA_IDS="$HOME/colcon_ws/src/ros2_camera_ids"
PATH_ROS2_CONFIG="$HOME/repos/ros2_config"
PATH_ROS2_INTERFACES="$HOME/colcon_ws/src/ros2_interfaces"
PATH_ROS2_LAUNCH="$HOME/colcon_ws/src/ros2_launch"
PATH_ROS2_ORBBEC_LAUNCH="$HOME/repos/ros2_orbbec_launch"
PATH_ROS2_UTILS="$HOME/colcon_ws/src/ros2_utils"

# Containers
DISTRIBUTION_ROS=humble
NAME_CONTAINER_ROS2_CAMERA_IDS=camera-ids
NAME_CONTAINER_ROS2_ORBBEC_LAUNCH=orbbec
NAME_CONTAINER_ROS2_PERSON_DETECTION_2D_LIDAR=person-detection-2d-lidar
NAME_CONTAINER_ROS2_PERSON_DETECTION=person-detection
NAME_CONTAINER_ROS2_PERSON_TRACKING=person-tracking

# RViz
QT_SCREEN_SCALE_FACTORS=1

set +a
