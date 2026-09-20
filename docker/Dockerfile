ARG BASE_IMAGE=ros:humble
ARG TARGET_PLATFORM=linux/amd64
FROM --platform=${TARGET_PLATFORM} ${BASE_IMAGE}

SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/ros2_ws
WORKDIR ${WORKSPACE}

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git nano python3-colcon-common-extensions \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

COPY . src/software-learning-period/
RUN source /opt/ros/humble/setup.bash \
    && rosdep update --rosdistro humble \
    && apt-get update \
    && rosdep install --from-paths src --ignore-src --rosdistro humble -y \
    && rm -rf /var/lib/apt/lists/* \
    && chmod 1777 /ros2_ws

# Interactive shells (including docker exec) must load ROS independently.
RUN printf '\nsource /opt/ros/humble/setup.bash\nif [ -f /ros2_ws/install/setup.bash ]; then source /ros2_ws/install/setup.bash; fi\n' >> /etc/bash.bashrc
ENV HOME=/tmp/learning-home
RUN mkdir -p "$HOME" && chmod 1777 "$HOME"
CMD ["bash"]
