FROM osrf/ros:iron-desktop-full

WORKDIR /ros_ws/src

SHELL ["/bin/bash", "-c"]

COPY ./src /ros_ws/src

RUN apt-get update && apt-get install -y \
    ros-iron-usb-cam \
    ros-iron-perception \
    python3-colcon-common-extensions \
    python3-opencv \
    python3-pip \
    && pip3 install setuptools==58.2.0 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "source /ros_ws/src/install/setup.bash" >> /root/.bashrc

RUN source /ros_ws/src/install/setup.bash

RUN source /ros_entrypoint.sh \
    && colcon build 

RUN cd /ros_ws \
    && colcon build --symlink-install \
    && colcon build --packages-select pub

ENTRYPOINT ["/bin/bash", "/ros_entrypoint.sh"]

CMD ["/bin/bash", "-c", "source /ros_ws/src/install/setup.bash && ros2 run pub talker"]