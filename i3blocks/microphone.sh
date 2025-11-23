#!/usr/bin/bash

function is_mute {
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -q '[[:space:]]0%[[:space:]]';
}

function toggle {
    pactl set-source-mute @DEFAULT_SOURCE@ no
    if is_mute; then
        pactl set-source-volume @DEFAULT_SOURCE@ 100%
    else
        pactl set-source-volume @DEFAULT_SOURCE@ 0%
    fi
}

case "$BLOCK_BUTTON" in
    1|4|5) toggle ;;
    2) ;;
    3) pavucontrol &> /dev/null & ;;
esac

#if $(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes); then
if is_mute; then
    echo '<span color="gray">MIC </span>';
else
    echo '<span color="gray">MIC </span>';
fi
