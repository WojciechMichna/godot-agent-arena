@echo off
echo Finding the next available n for container...

setlocal enabledelayedexpansion
set maxn=0
for /f %%a in ('docker ps --format "{{.Names}}" ^| findstr "vnc_docker_"') do (
    set name=%%a
    set num=!name:vnc_docker_=!
    if !num! gtr !maxn! set maxn=!num!
)
set /a n=%maxn%
set /a i=%maxn% + 1
set /a port1=9488 + %n%
set /a port2=5900 + %n%
set name=vnc_docker_%i% 
echo Starting container %name% on ports %port1% and %port2%
docker run ^
-e VNC_PASSWORD=123123 ^
-p %port1%:9488 ^
-v "%cd%\godot_projects":/mnt/godot_projects ^
-d  ^
--rm --name %name% --gpus all 0wojciechmichna/vnc_godot:0.1
endlocal