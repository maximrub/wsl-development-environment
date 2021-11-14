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

install_docker_engine(){
    log_info Installing docker engine
    
    sudo apt-get --yes remove docker docker-engine docker.io containerd runc || true
   
    sudo apt-get update --yes
    sudo apt-get --yes install ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update --yes
    sudo apt-get --yes install docker-ce docker-ce-cli containerd.io

    sudo groupadd docker || true
    sudo usermod -aG docker $USER
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service

    echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/dockerd" | sudo tee -a /etc/sudoers

    echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.bashrc
    echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.bashrc
    echo 'if [ -z "$RUNNING" ]; then' >> ~/.bashrc
    echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
    echo '    disown' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
    
    log_info docker engine installed
}

install_docker_compose(){
    log_info Installing docker compose

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    log_info docker compose installed
}

install_docker_engine
install_docker_compose