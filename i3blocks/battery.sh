#!/usr/bin/bash

case "$BLOCK_BUTTON" in
    1) ;;
    2) ;;
    3) ;;
    4) ;;
    5) ;;
esac

echo -n '<span color="gray">BAT </span>'

echo "$(cat /sys/class/power_supply/BAT0/capacity)%"

