-- ~/.config/hypr/modules/input.lua -- input device config
-- see https://wiki.hypr.land/configuring/core/config-options/#input

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1, -- 0. no mouse follow, 1. follow mouse (d), 2. no mouse follow expt floating windows, 3. no mouse follow at all
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
        off_window_axis_events = 2,
        -- repeat_delay = 400,
        -- repeat_rate  = 40,

        touchpad = {
            natural_scroll = false, -- set true for windows style, false for mac style
        },
    },
})

-- trackpad gestures
-- see https://wiki.hypr.land/configuring/core/binds/gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" }) -- three finger scroll sideways switches workspaces
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" }) -- four finger scroll sideways switches workspaces

-- alt + 3 finger swipe moves the active window to the left/right workspace
-- (lua gestures can't take a dispatcher name anymore, so they run a function)
hl.gesture({
    fingers = 3, direction = "left", mods = "ALT",
    action = function() hl.dispatch(hl.dsp.window.move({ workspace = "r+1" })) end,
})
hl.gesture({
    fingers = 3, direction = "right", mods = "ALT",
    action = function() hl.dispatch(hl.dsp.window.move({ workspace = "r-1" })) end,
})

hl.gesture({ fingers = 2, direction = "pinchin",  action = "float", mode = "tile"  }) -- pinch inwards to tile a window
hl.gesture({ fingers = 2, direction = "pinchout", action = "float", mode = "float" }) -- pinch outwards to float a window

-- example per-device config
-- see https://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
