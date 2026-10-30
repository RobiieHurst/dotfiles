-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Ultrawide on the left (3440 logical px wide), laptop to its right.
hl.monitor({ output = "eDP-1", mode = "2560x1600@300", position = "3440x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "HDMI-A-1", mode = "3440x1440@100", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3440x1440@100", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "3440x1440@100", position = "0x0", scale = 1 })
