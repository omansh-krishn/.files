-- ~/.config/hypr/modules/windowrules.lua -- window and layer rules
-- see https://wiki.hypr.land/configuring/core/rules/window-rules/ for more

-- ignore maximize requests from all apps. you'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- rules are evaluated top to bottom, so order matters.
-- regexes are RE2 (https://github.com/google/re2/wiki/Syntax).
-- build one "^(a|b|c)$" regex out of a list, so a list of
-- apps becomes one rule instead of one rule per app.
local function any_of(list)
    return "^(" .. table.concat(list, "|") .. ")$"
end

-- file dialogs
hl.window_rule({
    name  = "file-dialogs",
    match = { title = any_of({ "Sign in", "Open File", "Open", "Save", "Save As", "Export", "Import", "Choose File", "Rename", "Bitwarden" }) },

    float       = true,
    center      = true,
    border_size = 0,
})

-- XDG desktop portals
hl.window_rule({
    name  = "xdg-desktop-portals",
    match = { class = any_of({
        "xdg-desktop-portal-gtk",
        "xdg-desktop-portal-hyprland",
        "Xdg-desktop-portal-gtk",
        "Xdg-desktop-portal-hyprland",
    }) },

    float       = true,
    center      = true,
    border_size = 0,
})

-- program and application related rules
hl.window_rule({
    name  = "float-apps",
    match = { class = any_of({
        "org.pulseaudio.pavucontrol",      -- pavucontrol (volume control app)
        "nwg-look",                        -- nwg-look (GTK settings app)
        "org.gnome.NautilusPreviewer",     -- the preview window (gnome sushi)
        "mpv",                             -- mpv player
        "qalculate-gtk",                   -- qalculate (calculator app)
        "org.gnome.FileRoller",            -- file-roller (file unpacker app)
        "org.gnome.Loupe",                 -- gnome-loupe (image viewer)
        "com.github.finefindus.eyedropper",-- gnome-eyedropper (color picker)
        "localsend",                       -- localsend
    }) },

    float = true,
})

-- hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- layer rules
-- see https://wiki.hypr.land/configuring/core/rules/layer-rules/

-- blur vicinae window
hl.layer_rule({
    name  = "vicinae-blur",
    match = { namespace = "vicinae" },

    blur         = true,
    ignore_alpha = 0,
})

-- disable animation for vicinae only
-- hl.layer_rule({
--     name  = "vicinae-no-animation",
--     match = { namespace = "vicinae" },
--
--     no_anim = true,
-- })

-- hl.window_rule({ match = { float = true }, rounding = 8 }) -- rounded corners for floating windows
hl.window_rule({
    name  = "no-shadow-tiled",
    match = { float = false },
    no_shadow = true, -- no shadows on tiled windows
})
