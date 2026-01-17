#!/bin/sh
# Kill any existing swaybg instances so they don't stack up
pkill swaybg
swaybg -i /home/akashplackal/Downloads/wallpapers/samuraiBg.png -m fill &
