#!/bin/bash

pkill eww 2>/dev/null
sleep 0.3

mkdir -p ~/.config/eww/scripts
chmod +x ~/.config/eww/scripts/*.sh

eww daemon
eww open desktop

echo "Eww desktop launched successfully"
