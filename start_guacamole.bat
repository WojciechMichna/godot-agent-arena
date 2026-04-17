docker run -d ^
  --name guacamole ^
  -p 8080:8080 ^
  -v "%cd%\guacamole_config":/config ^
  oznu/guacamole