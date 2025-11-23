#!/usr/bin/bash

case "$BLOCK_BUTTON" in
    1) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    2) ;;
    3) pavucontrol &> /dev/null & ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

echo -n '<span color="gray">VOL </span>'

if $(pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes); then
    echo 'muted'
else
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Eowm1 '[0-9]+%' | head -1
fi
