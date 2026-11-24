-- ~/.config/hypr/modules/animations.lua -- animations
-- see https://wiki.hypr.land/configuring/core/animations/
-- (hyprland's default curves/animations are listed there and in the shipped example: /usr/share/hypr/hyprland.lua)

-- hl.config({
--     animations = {
--         enabled = false,
--     },
-- })

-- default curves, see https://wiki.hypr.land/configuring/core/animations/
-- hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}   } })
-- hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}   } })
-- hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}      } })
-- hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}   } })
-- hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}    } })

-- default animations
-- hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
-- hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- ref: https://github.com/end-4/dots-hyprland/blob/a2c164109061554ee11e6ee6806b29e7e8e89417/dots/.config/hypr/hyprland/general.conf (used as reference: animation{})
-- Author(s): end-4 <97237370+end-4@users.noreply.github.com> & contributors
-- License: GPLv3

hl.config({
    animations = {
        enabled = true,
    },
})

-- curves
hl.curve("expressiveFastSpatial",    { type = "bezier", points = { {0.42, 1.67}, {0.21, 0.90} } })
hl.curve("expressiveSlowSpatial",    { type = "bezier", points = { {0.39, 1.29}, {0.35, 0.98} } })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { {0.38, 1.21}, {0.22, 1.00} } })
hl.curve("emphasizedDecel",          { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })
hl.curve("emphasizedAccel",          { type = "bezier", points = { {0.3, 0},     {0.8, 0.15}  } })
hl.curve("standardDecel",            { type = "bezier", points = { {0, 0},       {0, 1}       } })
hl.curve("menu_decel",               { type = "bezier", points = { {0.1, 1},     {0, 1}       } })
hl.curve("menu_accel",               { type = "bezier", points = { {0.52, 0.03}, {0.72, 0.08} } })
hl.curve("stall",                    { type = "bezier", points = { {1, -0.1},    {0.7, 0.85}  } })

-- windows
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3, bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "fadeIn",      enabled = true, speed = 3, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2, bezier = "emphasizedDecel", style = "popin 90%" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" })
-- hl.animation({ leaf = "border",   enabled = true, speed = 10, bezier = "emphasizedDecel" })

-- layers
hl.animation({ leaf = "layersIn",  enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.4, bezier = "menu_accel",       style = "popin 94%" })

-- fade
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "stall" })

-- workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })

-- special workspace
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })

-- zoom
-- hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "standardDecel" })
