#!/bin/bash

chosen=$(printf "LOCK\nSLEEP\nPOWEROFF\nRESTART\nLOG OUT\nHIBERNATE" | rofi -dmenu -i -p "" -theme ~/.config/rofi/colors/minimal.rasi)

case "$chosen" in
    "LOCK")              bash ~/.config/qylock/quickshell-lockscreen/lock.sh ;;
    "SLEEP")             bash ~/.config/qylock/quickshell-lockscreen/lock.sh & systemctl suspend ;; # hyprlock
    "POWEROFF")          poweroff ;;
    "RESTART")           reboot ;;
    "LOG OUT")           hyprctl dispatch exit ;; #hyprshutdown
    "HIBERNATE")         bash ~/.config/qylock/quickshell-lockscreen/lock.sh & systemctl hibernate ;;
esac
