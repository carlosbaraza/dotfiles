#!/bin/bash

echo "Backing up 2019 to /Volumes/photo"
rsync --archive --verbose --human-readable ~/Pictures/2019 /Volumes/photo

echo "Backing up Lightroom to /Volumes/photo"
rsync --archive --verbose --human-readable ~/Pictures/Lightroom /Volumes/photo