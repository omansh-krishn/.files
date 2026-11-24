-- ~/.config/hypr/modules/keybinds.lua -- keybindings and shortcuts
-- see https://wiki.hypr.land/configuring/core/binds/
-- see https://wiki.hypr.land/configuring/core/dispatchers/

-- bind  -> hl.bind("MOD + KEY", dispatcher)
-- bindm -> { mouse = true }
-- bindl -> { locked = true } (works on lockscreen)
-- bindel -> { locked = true, repeating = true } (works on lockscreen, repeats when held)

local vars    = require("modules/vars")
local mainMod = vars.mainMod

-- application launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(vars.terminal)) -- terminal emulator
-- hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd(vars.fileManager)) -- file manager (re-add later; SUPER+ALT+F is maximize now)
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("/usr/bin/browser")) -- web browser # used for bt ...
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("vicinae toggle")) -- raycast clone
hl.bind("ALT + space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd([[emacsclient -n -a "" -c]]))
-- hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian")) -- note taking app (obsidian)
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.exec_cmd("rofi -show drun -display-drun '' -theme ~/.config/rofi/colors/minimal_mid.rasi || pkill rofi")) -- rofi
hl.bind("CTRL + Return", hl.dsp.exec_cmd(vars.terminal))

-- window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- kill active window
hl.bind(mainMod .. " + C", hl.dsp.window.close()) -- kill active window (duplicate)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill")) -- murder
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) -- toggle floating, pinch in on trackpad
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- centered pseudo mode ( dwindle )
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit")) -- switches b/w horizontal and vertical ( dwindle )

-- layout
hl.bind(mainMod .. " + bracketleft", function() -- super + [ - dwindle layout
    hl.config({ general = { layout = "dwindle" } })
end)
hl.bind(mainMod .. " + bracketright", function() -- super + ] - scrolling layout, see the scrolling section below
    hl.config({ general = { layout = "scrolling" } })
end)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- real fullscreen (covers bar and gaps)
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" })) -- maximize (keeps bar and gaps)
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.layout("colresize +conf")) -- cycle column widths ( scrolling )

-- focus movement (arrow keys and hjkl)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- swap windows
-- (vim style - hjkl)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.swap({ direction = "down" }))
-- arrow keys
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" }))

-- workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
-- hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
-- hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
-- hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
-- hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
-- hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
-- hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
-- hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
-- hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
-- hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- move window to workspace
-- hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
-- hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
-- hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
-- hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
-- hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
-- hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
-- hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
-- hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
-- hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
-- hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))

-- special workspace (scratchpad)
hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind("ALT + S",               hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("ALT + SHIFT + S",       hl.dsp.window.move({ workspace = "e+0" })) -- bring it back to the current workspace

-- workspace scrolling (active)
-- mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
-- keys
hl.bind("CTRL + ALT + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))

-- move and resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- waybar
hl.bind("CTRL + SHIFT + W", hl.dsp.exec_cmd("killall -SIGUSR1 waybar || ~/.config/waybar/scripts/launch.sh"))
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))
-- hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- hyprland
-- (`hyprctl dispatch` takes a lua expression now)
hl.bind("CTRL + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- scripts and other commands
-- hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/waybar/scripts/powermenu.sh")) -- conflits with dwindle pseudotile
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/waybar/scripts/powermenu.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("networkmanager_dmenu --config ~/.config/waybar/networkmanager_dmenu_config.ini"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("bzmenu -l rofi"))

-- audio
local lockedRepeat = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lockedRepeat)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      lockedRepeat)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     lockedRepeat)
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   lockedRepeat)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), lockedRepeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), lockedRepeat)

-- screenshots
-- hl.bind("Print",         hl.dsp.exec_cmd("grimblast -n copysave screen ~/Pictures/Screenshots/$(date +%d-%m-%y-%H%M%S).png")) -- ( full screen ) save in folder & copy to clip
-- hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast -n copysave area ~/Pictures/Screenshots/$(date +%d-%m-%y-%H%M%S).png"))   -- ( selection mode ) save in folder & copy to clip
-- hl.bind("CTRL + Print",  hl.dsp.exec_cmd("grimblast -n copysave active ~/Pictures/Screenshots/$(date +%d-%m-%y-%H%M%S).png")) -- ( active window ) save in folder & copy to clip
hl.bind("Print",         hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/Screenshots"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"))
hl.bind("CTRL + Print",  hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/Screenshots"))

-- scrolling layout (hyprscrolling plugin alt)
-- see https://wiki.hypr.land/configuring/layouts/scrolling-layout/
hl.bind(mainMod .. " + CTRL + period",  hl.dsp.layout("move +col")) -- scroll viewport right by one column
hl.bind(mainMod .. " + CTRL + comma",   hl.dsp.layout("move -col")) -- scroll viewport left by one column
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ direction = "right" })) -- move window to right column
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ direction = "left" }))  -- move window to left column
hl.bind(mainMod .. " + period",         hl.dsp.window.move({ direction = "up" }))    -- move window up
hl.bind(mainMod .. " + comma",          hl.dsp.window.move({ direction = "down" }))  -- move window down

-- other apps and misc
-- hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("qalculate-gtk")) -- opens the calculator application
-- hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("eyedropper")) -- opens the gnome-eyedropper tool
