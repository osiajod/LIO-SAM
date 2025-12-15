#!/bin/bash

# Check if both paths are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <code_base_path> <ros_bags_path>"
    echo "Example: $0 /home/bgarage/dev/LIOde-SAM_ws/src/LIO-SAM /home/bgarage/Downloads/ros_bags"
    exit 1
fi

CODE_BASE_PATH="$1"
ROS_BAGS_PATH="$2"

# Check if code_base path exists
if [ ! -d "$CODE_BASE_PATH" ]; then
    echo "Error: Code base directory $CODE_BASE_PATH does not exist"
    exit 1
fi

# Check if ros_bags path exists
if [ ! -d "$ROS_BAGS_PATH" ]; then
    echo "Error: ROS bags directory $ROS_BAGS_PATH does not exist"
    exit 1
fi

# Convert to absolute paths
CODE_BASE_PATH=$(realpath "$CODE_BASE_PATH")
ROS_BAGS_PATH=$(realpath "$ROS_BAGS_PATH")

echo "Mounting code base from: $CODE_BASE_PATH"
echo "Mounting ROS bags from: $ROS_BAGS_PATH"

docker run --init -it -d \
  --runtime nvidia \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  -v "$CODE_BASE_PATH:/root/catkin_ws/src/LIO-SAM" \
  -v "$ROS_BAGS_PATH:/root/ros_bags" \
  liosam-kinetic-xenial2 \
  bash

# At ~/catkin_ws run:
  # catikin_make
  # . devel/setup.bash
## In terminal 1
  # roslaunch lio_sam run.launch
## In terminal 2 
  # rosbag play /root/ros_bags/park_dataset.bag -r 3

