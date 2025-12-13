#!/bin/bash
docker run --init -it -d \
  --runtime nvidia \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  liosam-kinetic-xenial \
  bash