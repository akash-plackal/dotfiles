#!/bin/sh

# Wallpaper
pkill swaybg
swaybg -i /home/akashplackal/Downloads/wallpapers/samuraiBg.png -m fill &

# Ensure any old wl-paste watchers are killed
pkill wl-paste

# Primary selection behaves like normal copy
wl-paste --primary --watch wl-copy --primary &

# Optional clipboard history (cliphist)
wl-paste --type text --watch cliphist store &
