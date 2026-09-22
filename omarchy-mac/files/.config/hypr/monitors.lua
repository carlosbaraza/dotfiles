-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Monitor scale is Hyprland's scale for the output. It sizes everything
-- Wayland-native, accepts fractions (1.6, 1.75), and applies immediately.
-- "auto" lets Hyprland pick per display.
-- The native 3456x2234 mode does not divide evenly by 1.75.
-- Permit fractional logical dimensions for the requested desktop scale.
hl.config({ debug = { disable_scale_checks = true }, xwayland = { force_zero_scaling = false } })
local omarchy_monitor_scale = 1.75
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Let the compositor scale legacy XWayland apps too; avoid applying GTK 2x
-- scaling on top. Existing legacy apps need restarting to inherit this value.
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
