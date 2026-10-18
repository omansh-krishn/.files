#!/bin/bash

chosen=$(printf "LOCK\nSLEEP\nPOWEROFF\nRESTART\nLOG OUT\nHIBERNATE" | rofi -dmenu -i -p "" -theme ~/.config/rofi/colors/minimal.rasi)

case "$chosen" in
    "LOCK")              loginctl lock-session ;;
    "SLEEP")             systemctl suspend ;; # hyprlock
    "POWEROFF")          poweroff ;;
    "RESTART")           reboot ;;
    "LOG OUT")           hyprctl dispatch exit ;; #hyprshutdown
    "HIBERNATE")         systemctl hibernate ;;
esac
