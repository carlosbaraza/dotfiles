#!/bin/bash

if [[ -z "${BACKUP_ROOT}" ]]; then
  echo "BACKUP_ROOT must be set"
  exit 1
fi

DATE=$(date +%Y%m%d%H%M%S)
DRIVE_BACKUP=$BACKUP_ROOT/$DATE

echo "Backing up to $DRIVE_BACKUP"
mkdir -p "$DRIVE_BACKUP"

echo "Copy ~/.ssh"
cp -r ~/.ssh "$DRIVE_BACKUP"

echo "Copy ~/.zsh_history"
cp ~/.zsh_history "$DRIVE_BACKUP"