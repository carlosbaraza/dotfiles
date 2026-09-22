-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Mac Fn/globe: hold to dictate, release to transcribe.
-- Linux KEY_FN (464) + XKB offset (8) = 472.
o.bind("code:472", "Start dictation (Fn)", "voxtype record start")
o.bind("code:472", "Stop dictation (Fn)", "voxtype record stop", { release = true })

-- AeroSpace muscle memory. Option is ALT on Linux.
-- Replace the earlier Command-number shortcuts, including desktop 10.
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
end

local function mac_bind(key, description, action)
  hl.unbind(key)
  o.bind(key, description, action)
end

local function desktop(key, name, selector)
  hl.workspace_rule({ workspace = selector, persistent = true })
  mac_bind("ALT + " .. key, "Switch to workspace " .. name, hl.dsp.focus({ workspace = selector }))
  mac_bind("ALT + SHIFT + " .. key, "Move window to workspace " .. name,
    hl.dsp.window.move({ workspace = selector, follow = false }))
end

for workspace = 1, 9 do
  desktop("code:" .. tostring(workspace + 9), tostring(workspace), tostring(workspace))
end
-- H/J/K/L are reserved for directional navigation, just as on the Mac.
for letter in ("A B C D E F G I M N O P Q R S T U V W X Y Z"):gmatch("%S+") do
  desktop(letter, letter, "name:" .. letter)
end

for _, item in ipairs({ { "H", "l", "left" }, { "J", "d", "down" }, { "K", "u", "up" }, { "L", "r", "right" } }) do
  mac_bind("ALT + " .. item[1], "Focus window " .. item[3], hl.dsp.focus({ direction = item[2] }))
  mac_bind("ALT + SHIFT + " .. item[1], "Move window " .. item[3], hl.dsp.window.move({ direction = item[2] }))
end

-- Previously Alt+Tab / Alt+Shift+Tab cycled application windows.
mac_bind("ALT + TAB", "Previous desktop (AeroSpace)", hl.dsp.focus({ workspace = "previous" }))
mac_bind("ALT + SHIFT + TAB", "Move desktop to next monitor", hl.dsp.workspace.move({ monitor = "+1" }))
mac_bind("ALT + SHIFT + SPACE", "Toggle fullscreen (AeroSpace)", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
mac_bind("ALT + code:20", "Shrink window (AeroSpace)", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
mac_bind("ALT + code:21", "Grow window (AeroSpace)", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
-- Dwindle's closest native equivalent to balance-sizes: equalize the active split.
mac_bind("ALT + code:19", "Equalize active split", hl.dsp.layout("splitratio 1 exact"))

-- Personal Command+C / Command+V behavior, retained from Omarchy defaults.
-- Send with explicit mods to the focused surface by omitting the window target,
-- so universal clipboard shortcuts reach both normal windows and focused
-- layer-shell surfaces such as Omarchy panels. A virtual keyboard (wtype) won't
-- do: the physically held SUPER merges into the injected chord at the seat.
-- The down/up split works around Hyprland send_shortcut sometimes leaving
-- synthetic key state stuck/repeating.
-- https://github.com/hyprwm/Hyprland/discussions/14099
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- Lean on the terminal tag from default/hypr/apps/terminals.lua so there's one
-- definition of what counts as a terminal. Dynamic tags carry a trailing "*".
local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

hl.unbind("SUPER + C") -- Replace Omarchy Universal copy with the same personal binding.
o.bind("SUPER + C", "Universal copy", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
hl.unbind("SUPER + V") -- Replace Omarchy Universal paste with the same personal binding.
o.bind("SUPER + V", "Universal paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))

-- macOS Chrome shortcuts. Keep the existing desktop action outside Chrome.
local function chrome_bind(chord, description, mods, key, fallback)
  hl.unbind(chord)
  o.bind(chord, "Chrome: " .. description, function()
    local window = hl.get_active_window()
    local class = window and (window.class or ""):lower() or ""
    if class == "chromium" or class == "chromium-browser"
        or class == "google-chrome" or class == "google-chrome-stable"
        or class == "google-chrome-beta" or class == "google-chrome-unstable" then
      send_shortcut_once(mods, key)()
    elseif fallback then
      hl.dispatch(fallback)
    end
  end)
end

chrome_bind("SUPER + T", "New tab", "CTRL", "T", hl.dsp.window.float({ action = "toggle" }))
chrome_bind("SUPER + W", "Close tab", "CTRL", "W", hl.dsp.window.close())
chrome_bind("SUPER + L", "Address bar", "CTRL", "L", hl.dsp.exec_cmd("omarchy-hyprland-workspace-layout-toggle"))
chrome_bind("SUPER + F", "Find", "CTRL", "F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
chrome_bind("SUPER + G", "Find next", "CTRL", "G", hl.dsp.group.toggle())
chrome_bind("SUPER + SHIFT + N", "Incognito window", "CTRL SHIFT", "N", hl.dsp.exec_cmd("omarchy-launch-editor"))
chrome_bind("SUPER + SHIFT + B", "Bookmarks bar", "CTRL SHIFT", "B", hl.dsp.exec_cmd("omarchy-launch-browser"))
chrome_bind("SUPER + ALT + LEFT", "Previous tab", "CTRL", "Prior", hl.dsp.window.move({ into_group = "l" }))
chrome_bind("SUPER + ALT + RIGHT", "Next tab", "CTRL", "Next", hl.dsp.window.move({ into_group = "r" }))
chrome_bind("SUPER + LEFT", "Back", "ALT", "Left", hl.dsp.focus({ direction = "l" }))
chrome_bind("SUPER + RIGHT", "Forward", "ALT", "Right", hl.dsp.focus({ direction = "r" }))
chrome_bind("SUPER + code:20", "Zoom out", "CTRL", "minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
chrome_bind("SUPER + code:21", "Zoom in", "CTRL", "equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
chrome_bind("SUPER + SHIFT + code:21", "Zoom in", "CTRL", "equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

for _, item in ipairs({
  { "SHIFT + T", "Reopen closed tab", "CTRL SHIFT", "T" },
  { "N", "New window", "CTRL", "N" },
  { "R", "Reload", "CTRL", "R" },
  { "SHIFT + R", "Reload without cache", "CTRL SHIFT", "R" },
  { "A", "Select all", "CTRL", "A" },
  { "Z", "Undo", "CTRL", "Z" },
  { "SHIFT + Z", "Redo", "CTRL SHIFT", "Z" },
  { "D", "Bookmark page", "CTRL", "D" },
  { "Y", "History", "CTRL", "H" },
  { "SHIFT + J", "Downloads", "CTRL", "J" },
  { "ALT + I", "Developer tools", "CTRL SHIFT", "I" },
  { "ALT + J", "JavaScript console", "CTRL SHIFT", "J" },
  { "code:34", "Back", "ALT", "Left" },
  { "code:35", "Forward", "ALT", "Right" },
  { "code:19", "Reset zoom", "CTRL", "0" },
}) do
  chrome_bind("SUPER + " .. item[1], item[2], item[3], item[4])
end
for index = 1, 9 do
  chrome_bind("SUPER + code:" .. tostring(index + 9), "Tab " .. index, "CTRL", tostring(index))
end

-- Modal window switcher: capture shortcuts until selection/cancellation.
local function switcher_ipc(action)
  hl.dispatch(hl.dsp.exec_cmd("quickshell -c mac-switcher ipc call switcher " .. action))
end
local function open_switcher(action)
  hl.dispatch(hl.dsp.submap("mac-switcher"))
  switcher_ipc(action)
end
local function finish_switcher(action)
  if hl.get_current_submap() ~= "mac-switcher" then return end
  hl.dispatch(hl.dsp.submap("reset"))
  switcher_ipc(action)
end
mac_bind("SUPER + TAB", "Recent window switcher", function() open_switcher("next") end)
mac_bind("SUPER + SHIFT + TAB", "Recent window switcher backwards", function() open_switcher("previous") end)
-- Command was pressed before entering the submap; universal release handles it.
for _, key in ipairs({ "Super_L", "Super_R" }) do
  o.bind(key, "Commit window switcher", function() finish_switcher("commit") end,
    { release = true, ignore_mods = true, non_consuming = true, transparent = true, submap_universal = true })
end
hl.define_submap("mac-switcher", function()
  for _, key in ipairs({ "SUPER + TAB", "SUPER + Down", "SUPER + J" }) do
    o.bind(key, "Switcher: next window", function() switcher_ipc("next") end, { repeating = true })
  end
  for _, key in ipairs({ "SUPER + SHIFT + TAB", "SUPER + Up", "SUPER + K" }) do
    o.bind(key, "Switcher: previous window", function() switcher_ipc("previous") end, { repeating = true })
  end
  o.bind("SUPER + W", "Switcher: close highlighted window", function() switcher_ipc("closeSelected") end)
  o.bind("Escape", "Cancel window switcher", function() finish_switcher("cancel") end, { ignore_mods = true })
  o.bind("Return", "Select window", function() finish_switcher("commit") end, { ignore_mods = true })
  -- Swallow all other keys instead of sending them to the active application.
  hl.bind("catchall", function() end, { ignore_mods = true })
end)
