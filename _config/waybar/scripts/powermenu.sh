#!/bin/bash

chosen=$(printf "LOCK\nSLEEP\nPOWEROFF\nRESTART\nLOG OUT\nHIBERNATE" | rofi -dmenu -i -p "" -theme ~/.config/rofi/colors/minimal.rasi)

case "$chosen" in
    "LOCK")              bash ~/.config/qylock/quickshell-lockscreen/lock.sh ;;
    "SLEEP")             bash ~/.config/qylock/quickshell-lockscreen/lock.sh & loginctl suspend ;; # hyprlock
    "POWEROFF")          loginctl poweroff ;;
    "RESTART")           loginctl reboot ;;
    "LOG OUT")           hyprctl dispatch exit ;; #hyprshutdown
    "HIBERNATE")         bash ~/.config/qylock/quickshell-lockscreen/lock.sh & loginctl hibernate ;;
esac
