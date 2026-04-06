docker run ^
-e VNC_PASSWORD=dupa  ^
-p 9488:9488  ^
-v "%cd%\godot_projects":/mnt/godot_projects ^
--rm --name vnc_docker --gpus all 0wojciechmichna/vnc_godot:0.1
