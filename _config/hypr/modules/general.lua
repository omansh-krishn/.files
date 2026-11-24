-- ~/.config/hypr/modules/general.lua -- general configurations
-- see https://wiki.hypr.land/configuring/core/config-options/

local theme = require("modules/themes/current")

-- look and feel
-- check https://wiki.hypr.land/configuring/core/config-options/#general
hl.config({
    general = {
        gaps_in     = 4, -- gap size between tiled windows
        gaps_out    = 8, -- gap size around the desktop (kinda like borders)
        border_size = 2, -- border size of a window

        -- colors come from modules/themes/current.lua
        col = {
            active_border   = theme.active_border,
            inactive_border = theme.inactive_border,
        },

        resize_on_border = false, -- set to true enable resizing windows by clicking and dragging on borders and gaps
        allow_tearing    = false, -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on

        -- layout = "master", -- like i3
        -- layout = "scrolling", -- built-in, see the scrolling block below. switch live with SUPER + ]
        layout = "dwindle", -- default layout. switch live with SUPER + [ / SUPER + ]
    },
})

-- see https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- you probably want this
        force_split    = 2,    -- new splits position in the right/bottom. 0 - follows mouse, 1 - left/top (default), 2 - right/bottom
    },
})

-- see https://wiki.hypr.land/configuring/layouts/master-layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- scrolling is a built-in layout now (replaces the old hyprscrolling plugin)
-- see https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more info
hl.config({
    scrolling = {
        column_width             = 0.7,  -- each column takes 70% of screen width
        fullscreen_on_one_column = true, -- maximize window when only one column is visible
        follow_focus             = 1,    -- 0: focus doesn't move the tape, 1: may move it (click always does), 2: may move it
        focus_fit_method         = 1,    -- 0 = center, 1 = fit focused column into view
        explicit_column_widths   = "0.333, 0.5, 0.667, 1.0", -- cycled with colresize +conf
    },
})

-- see https://wiki.hypr.land/configuring/core/config-options/#misc for more info
-- ref: https://github.com/end-4/dots-hyprland/blob/a2c164109061554ee11e6ee6806b29e7e8e89417/dots/.config/hypr/hyprland/general.conf (used as reference: misc{}, xwayland{})
-- Author(s): end-4 <97237370+end-4@users.noreply.github.com> & contributors
-- License: GPLv3
hl.config({
    misc = {
        force_default_wallpaper      = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers -- not weeb enough to care.
        disable_hyprland_logo        = true, -- If true disables the random hyprland logo / anime girl background. :( -- wtf?!
        disable_splash_rendering     = true, -- when true, disables the random quotes
        vrr                          = 0,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,
        enable_swallow               = false,
        on_focus_under_fullscreen    = 2,
        allow_session_lock_restore   = true,
        session_lock_xray            = true,
        initial_workspace_tracking   = false,
        focus_on_activate            = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})
