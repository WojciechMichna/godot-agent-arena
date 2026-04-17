docker run ^
-e VNC_PASSWORD=123123  ^
-p 9488:9488  ^
-p 5900:5900  ^
-v "%cd%\godot_projects":/mnt/godot_projects ^
--rm --name vnc_docker --gpus all 0wojciechmichna/vnc_godot:0.1
