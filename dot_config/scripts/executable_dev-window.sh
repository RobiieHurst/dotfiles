#!/bin/bash

# Get the current tmux session (VSCode typically names it with process ID)
CURRENT_SESSION=$(tmux display-message -p '#S')

# Create a new window in the current session
tmux new-window -t $CURRENT_SESSION
WINDOW_INDEX=$(tmux display-message -p '#I')

# Rename the window
tmux rename-window -t $CURRENT_SESSION:$WINDOW_INDEX 'dev'

# Create a 2x2 grid of equal-sized panes
tmux split-window -h -p 50 # Split horizontally in half
tmux select-pane -t 1      # Select the left pane
# tmux split-window -v -p 50 # Split left pane vertically in half
# tmux select-pane -t 3      # Select the right pane
# tmux split-window -v -p 50 # Split right pane vertically in half

# Set up each pane
# Pane 1 - express server
tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX.1 'node --inspect express.js' C-m

# Pane 2 - build process
tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX.2 'npx nodemon --exec "npx concurrently \"node esbuild.config.mjs\" \"npm run ui_css\" \"npm run mapp_css\""' C-m

# # Pane 3 - browser-sync
# tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX.3 'npm run browser-sync' C-m
#
# # Pane 4 - test logs
# # tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX.4 'tail -f /tmp/chrome_debug.log | grep -v "VERBOSE1\|<userStyle>"' C-m
# tmux send-keys -t $CURRENT_SESSION:$WINDOW_INDEX.4 'tail -f /tmp/chrome_debug.log | perl -pe '\''s/\[.*?\] "//g; s/".*$//'\''' C-m

# Select first pane
tmux select-pane -t $CURRENT_SESSION:$WINDOW_INDEX.1
