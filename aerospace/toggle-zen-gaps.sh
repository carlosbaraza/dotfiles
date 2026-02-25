#!/bin/bash
# Toggle zen gaps on the BenQ ultrawide only (built-in stays at 4).
# Usage: toggle-zen-gaps.sh <left-right-gap> [top-bottom-gap]
# Press same key again to toggle back to normal.

CONFIG="$HOME/dotfiles/aerospace/.aerospace.toml"

ZEN_LR=${1:-500}
ZEN_TB=${2:-80}
NORMAL=4

# Read current BenQ left gap value
CURRENT=$(grep "outer\.left" "$CONFIG" | grep -o "BenQ EX3501R' = [0-9]*" | grep -o '[0-9]*$')

if [ "$CURRENT" -eq "$ZEN_LR" ] 2>/dev/null; then
    # Toggle back to normal
    sed -i '' "/outer\.left/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $NORMAL/" "$CONFIG"
    sed -i '' "/outer\.right/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $NORMAL/" "$CONFIG"
    sed -i '' "/outer\.top/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $NORMAL/" "$CONFIG"
    sed -i '' "/outer\.bottom/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $NORMAL/" "$CONFIG"
else
    # Set zen gaps on BenQ only
    sed -i '' "/outer\.left/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $ZEN_LR/" "$CONFIG"
    sed -i '' "/outer\.right/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $ZEN_LR/" "$CONFIG"
    sed -i '' "/outer\.top/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $ZEN_TB/" "$CONFIG"
    sed -i '' "/outer\.bottom/s/BenQ EX3501R' = [0-9]*/BenQ EX3501R' = $ZEN_TB/" "$CONFIG"
fi

aerospace reload-config
