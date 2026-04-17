#!/bin/sh

export DISPLAY=:99

if [ -d /mnt/godot_projects ]; then
  cp -R /mnt/godot_projects/* /root
fi

nohup /opt/godot --maximized > /dev/null 2>&1 &
