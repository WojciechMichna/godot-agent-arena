#!/bin/sh

export DISPLAY=:99
export VGL_SPOIL=0
export VGL_SYNC=1


if [ -d /mnt/godot_projects ]; then
  cp -R /mnt/godot_projects/* /root
fi

nohup vglrun /opt/godot > /dev/null 2>&1 &
