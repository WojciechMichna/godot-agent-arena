docker run ^
-e VNC_PASSWORD=dupa ^
-p 9488:9488 ^
--rm --name vnc_docker_gpu --gpus all 0wojciechmichna/vnc_godot:0.1-gpu
