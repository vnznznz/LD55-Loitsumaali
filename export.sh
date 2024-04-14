#!/bin/bash
set -e

mkdir -p export/web

GODOT_PATH="$HOME/work/tools/godot/Godot_v3.5.3-stable_x11.64"



$GODOT_PATH --no-window --export "HTML5"

# delete zip if it exists
if [ -f ./export/web.zip ]; then
  rm ./export/web.zip
fi
cd export
zip -r ./web.zip ./web/
cd ..


$HOME/.config/itch/apps/butler/butler push export/web.zip vnznz/ld55:web-export
