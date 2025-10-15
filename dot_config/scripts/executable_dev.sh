#!/bin/bash
set -x # Print commands for debugging

tmux new-window \; \
  rename-window 'express' \; \
  send-keys 'node --inspect express.js' C-m \; \
  new-window \; \
  rename-window 'build' \; \
  send-keys 'npx nodemon --exec npx concurrently "node esbuild.config.mjs" "npm run ui_css" "npm run mapp_css"' C-m \; \
  new-window \; \
  rename-window 'logs' \; \
  send-keys 'tail -f /tmp/chrome_debug.log | perl -pe '\''s/\[.*?\] "//g; s/".*$//'\''' C-m \; \
  select-window -t express

