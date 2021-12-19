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

log_info Installing Go

curl -L https://dl.google.com/go/go1.17.5.linux-amd64.tar.gz -o /tmp/go1.17.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /tmp/go1.17.5.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile

log_info Go installed
