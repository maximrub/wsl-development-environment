#!/bin/bash

cd "$(dirname "$0")"

set -u # Will exit script if we would use an uninitialized variable
set -e # Will exit script when a simple command (not a control structure) fails

# log_info message ...
#
# Writes the given messages in green letters to standard output.
#
# Example:
# log_info "Starting install"
#
log_info(){
    local green=$(tput setaf 2)
    local reset=$(tput sgr0)
    echo -e "${green}$@${reset}"
}

log_info Installing Chrome

sudo curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb
sudo apt install /tmp/google-chrome-stable_current_amd64.deb

log_info Chrome installed