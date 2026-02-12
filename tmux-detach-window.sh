#!/bin/bash
# Move current tmux window to a new session in a new Ghostty window

WINDOW_NAME=$(tmux display-message -p '#W')
SESSION_NAME=$(tmux display-message -p '#S')
WINDOW_INDEX=$(tmux display-message -p '#I')

# Sanitize for tmux session name: keep only alphanumeric, hyphens, underscores
SAFE_NAME=$(echo "$WINDOW_NAME" | tr -c '[:alnum:]-_' '-' | sed 's/^-//;s/-$//')

# Fallback if name is empty after sanitization
if [ -z "$SAFE_NAME" ]; then
  SAFE_NAME="detached"
fi

# Avoid collision with existing session names
if tmux has-session -t "=$SAFE_NAME" 2>/dev/null; then
  SAFE_NAME="${SAFE_NAME}-$(date +%s)"
fi

# Create new detached session (comes with a throwaway window)
tmux new-session -d -s "$SAFE_NAME"

# Link our window into the new session, replacing the default window
tmux link-window -k -s "${SESSION_NAME}:${WINDOW_INDEX}" -t "${SAFE_NAME}:1"

# Unlink from original session (this is the "move")
tmux unlink-window -t "${SESSION_NAME}:${WINDOW_INDEX}"

# Open new Ghostty window attached to the new session
# Each argument to -e must be separate (not a single quoted string)
open -na "Ghostty" --args -e tmux attach-session -t "$SAFE_NAME"
