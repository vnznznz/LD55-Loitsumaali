#!/bin/bash
set -e

mkdir -p export/web

GODOT_PATH="$HOME/work/tools/godot/Godot_v3.5.3-stable_x11.64"



$GODOT_PATH --no-window --export "HTML5"
$GODOT_PATH --no-window --export "Linux"
$GODOT_PATH --no-window --export "Mac"
$GODOT_PATH --no-window --export "Windows"

# delete zip if it exists
if [ -f ./export/web.zip ]; then
  rm ./export/web.zip
fi
cd export
zip -r ./web.zip ./web/
cd ..


$HOME/.config/itch/apps/butler/butler push export/web.zip vnznz/ld55-loitsumaali:web-export
$HOME/.config/itch/apps/butler/butler push export/linux vnznz/ld55-loitsumaali:linux
$HOME/.config/itch/apps/butler/butler push export/windows vnznz/ld55-loitsumaali:windows
$HOME/.config/itch/apps/butler/butler push export/mac vnznz/ld55-loitsumaali:mac
