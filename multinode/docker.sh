#!/usr/bin/env bash

# check docker is installed
if command -v docker >/dev/null 2>&1; then
    echo "Docker is installed."
    # check docker is running
    #if docker info >/dev/null 2>&1; then
    #    echo "Docker service is running."
    #else
    #    echo "Docker service is not running."
    #fi
else
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl software-properties-common apt-transport-https
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" 
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo service docker restart
fi
