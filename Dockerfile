# Using Ubuntu Focal base for ARM compatibility (works on both x86_64 and ARM64)
# The osrf/ros images don't have ARM64 variants, so we install ROS kinetic manually
FROM ubuntu:xenial

# Install ROS kinetic and system dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        git \
        gnupg2 \
        lsb-release \
        vim \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ros-kinetic-desktop-full \
        ros-kinetic-navigation \
        ros-kinetic-robot-localization \
        ros-kinetic-robot-state-publisher \
        ros-kinetic-vision-opencv \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:borglab/gtsam-release-4.0 \
    && apt-get update \
    && apt install -y \
        libgtsam-dev \
        libgtsam-unstable-dev \
        libopencv-dev
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# Create workspace directory structure (this rarely changes, so cache it early)
RUN mkdir -p ~/catkin_ws/src

# Setup bashrc (rarely changes)
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc \
    && echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Clone repository and build (put last to minimize rebuild time when code changes)
# Note: This will be overridden if a host folder is mounted via run_docker.sh
# Using HTTPS for Docker build (if SSH is needed, configure SSH keys in Dockerfile)

RUN cd ~/catkin_ws \
    && source /opt/ros/kinetic/setup.bash \
    && catkin_make

WORKDIR /root/catkin_ws
