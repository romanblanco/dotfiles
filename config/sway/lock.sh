#!/bin/bash
# put task in background
swayidle \
    timeout 5 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
# lcok screen
swaylock -c000000
# kill last background task
kill %%

# https://github.com/swaywm/swaylock/issues/49#issuecomment-462143402
