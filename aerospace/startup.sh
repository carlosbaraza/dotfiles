#!/bin/bash
# AeroSpace startup script — opens apps and assigns them to workspaces.
# Called from after-startup-command in .aerospace.toml
# Skips apps that already have windows in the target workspace.

# Check if an app already has a window in a given workspace.
# Usage: app_in_workspace <bundle-id> <workspace>
app_in_workspace() {
  aerospace list-windows --workspace "$2" --format '%{app-bundle-id}' 2>/dev/null \
    | grep -q "$1"
}

# Helper: open an app and move ALL its windows to a workspace (if not already there).
open_and_move_all() {
  local bundle_id="$1"
  local workspace="$2"

  if app_in_workspace "$bundle_id" "$workspace"; then
    return
  fi

  open -b "$bundle_id"
  sleep 2

  aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}' 2>/dev/null \
    | grep "$bundle_id" \
    | cut -d'|' -f1 \
    | while read -r wid; do
        aerospace move-node-to-workspace --window-id "$wid" "$workspace"
      done
}

# --- Workspace D: Browser ---
if ! app_in_workspace "com.google.Chrome" "D"; then
  open -b "com.google.Chrome"
  sleep 3
  aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}' 2>/dev/null \
    | grep "com.google.Chrome" \
    | cut -d'|' -f1 \
    | while read -r wid; do
        aerospace move-node-to-workspace --window-id "$wid" "D"
      done
fi

# --- Workspace G: Home Assistant (new Chrome window) ---
if ! app_in_workspace "com.google.Chrome" "G"; then
  open -na "Google Chrome" --args --new-window "https://arroyo.baraza.io"
  sleep 2
  NEW_WID=$(aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}|%{workspace}' 2>/dev/null \
    | grep "com.google.Chrome" \
    | grep -v "|D$" \
    | grep -v "|G$" \
    | head -1 | cut -d'|' -f1)
  if [ -n "$NEW_WID" ]; then
    aerospace move-node-to-workspace --window-id "$NEW_WID" "G"
  fi
fi

# --- Workspace R: Claude ---
open_and_move_all "com.anthropic.claudefordesktop" "R"

# --- Workspace F: Linear ---
open_and_move_all "com.linear" "F"

# --- Workspace A: Telegram ---
open_and_move_all "com.tdesktop.Telegram" "A"

# --- Workspace W: WhatsApp & Signal ---
open_and_move_all "net.whatsapp.WhatsApp" "W"
open_and_move_all "org.whispersystems.signal-desktop" "W"

# --- Workspace C: Calendar ---
open_and_move_all "com.apple.iCal" "C"

# --- Workspace V: Obsidian ---
open_and_move_all "md.obsidian" "V"

# --- Workspace P: 1Password ---
open_and_move_all "com.1password.1password" "P"

# --- Workspace S: Slack ---
open_and_move_all "com.tinyspeck.slackmacgap" "S"

# --- Workspace E: Terminal (single window running tmux) ---
if ! app_in_workspace "com.mitchellh.ghostty" "E"; then
  /Applications/Ghostty.app/Contents/MacOS/ghostty -e tmux &
  sleep 2
  WID=$(aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}' 2>/dev/null \
    | grep "com.mitchellh.ghostty" | head -1 | cut -d'|' -f1)
  if [ -n "$WID" ]; then
    aerospace move-node-to-workspace --window-id "$WID" "E"
  fi
fi

# Focus workspace E to start
aerospace workspace E || true
