#!/bin/bash

set -e # fail on error

# include hidden files 
# https://askubuntu.com/questions/740805/how-can-i-remove-all-files-from-current-directory-using-terminal
shopt -s dotglob
echo "Cleaning up Workspace directory."
rm -rf *

# Cleanup home directory
echo "Cleaning up home directory."
[[ -d "$HOME" ]] && cd "$HOME" && rm -rf *

# Cleanup event json
echo "Cleaning up event.json."
[[ -f "$GITHUB_EVENT_PATH" ]] && rm $GITHUB_EVENT_PATH

echo "Post job cleanup complete."
