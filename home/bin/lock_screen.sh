#!/usr/bin/env bash

display_resolution="$(xdpyinfo | grep dimensions | awk '{print $2}')"
default_timeout="$(cut -d ' ' -f4 <<< $(xset q | sed -n '25p'))"

screen_capture=/tmp/bg_screenshot.png
screen_capture_blurred=/tmp/bg_screenshot_blur.png

scrot "${screen_capture}" -z
convert "${screen_capture}" -scale 2.5% -resize 4000% "${screen_capture_blurred}"
i3lock -i "${screen_capture_blurred}"
