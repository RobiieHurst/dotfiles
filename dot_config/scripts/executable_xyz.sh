#!/bin/bash

# Set your target directory here (without ~ expansion)
TARGET_DIR="/Users/roberthurst/Documents/geolytix.nosync/xyz/"

# Get the current tmux session
CURRENT_SESSION=$(tmux display-message -p '#S')

# Change the original window's directory first
tmux send-keys -t $CURRENT_SESSION "cd $TARGET_DIR" C-m

# Create a new window in the current session with the target directory
tmux new-window -t $CURRENT_SESSION -c $TARGET_DIR
WINDOW_INDEX=$(tmux display-message -p '#I')

# Rename the window
tmux rename-window -t $CURRENT_SESSION:$WINDOW_INDEX 'nvim'

# Open nvim
tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX "nvim" C-m
