#!/bin/sh

# 1. Configure Password
mkdir -p /root/.vnc
x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd

# 2. Xvfb - Screen
nohup Xvfb :99 -screen 0 1366x768x24 > /dev/null 2>&1 &
sleep 2
export DISPLAY=:99

# 3. (Openbox) Window Manager
nohup openbox-session > /dev/null 2>&1 &

# 4. x11vnc and websockify
nohup x11vnc -display :99 -rfbauth /root/.vnc/passwd -rfbport 5900 -forever -listen 0.0.0.0 -bg > /dev/null 2>&1 &
sleep 1
nohup websockify --web /opt/novnc 9488 localhost:5900 --heartbeat 30 > /dev/null 2>&1 &
