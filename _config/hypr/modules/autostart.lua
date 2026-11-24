-- ~/.config/hypr/modules/autostart.lua -- run on startup
-- autostart necessary processes (like notifications daemons, status bars, etc.)
-- see https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")

    -- system services
    -- hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    -- hl.exec_cmd("systemctl --user start xdg-desktop-portal")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal -r")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    -- hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent0")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- display and wallpaper
    -- hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hyprctl setcursor Bibata-Original-Ice 24")

    -- status bar and notifications
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")

    -- network and bluetooth
    hl.exec_cmd("nm-applet --indicator")
    -- hl.exec_cmd("blueman-applet")

    -- clipboard
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- other
    hl.exec_cmd("vicinae server --no-extension-runtime") -- raycast clone
end)
