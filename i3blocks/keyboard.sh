#!/usr/bin/bash

case "$BLOCK_BUTTON" in
    1|4|5) setxkbmap -query | grep -q 'layout: *tr' && setxkbmap us || setxkbmap tr ;;
    2) ;;
    3) ;;
esac

setxkbmap -query | sed -rn 's/layout: *(.+)$/\1/p'
