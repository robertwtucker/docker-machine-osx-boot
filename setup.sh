#!/bin/bash
# This script installs the components necessary to start the default Docker
# host machine when OSX boots. It also modifies ~/.bash_profile so that
# the Docker environment variables automatically get created.
set -o errexit

DOCKER_MACHINE=$(which docker-machine)
if [ ! -f $DOCKER_MACHINE ]; then
  echo "Docker Machine not found/not installed. Please re-run the Docker Toolbox Installer and try again."
  exit 1
fi

curl -fs https://raw.githubusercontent.com/robertwtucker/docker-machine-osx-boot/master/plist.template | \
  sed -e "s/{{user-path}}/$(echo $PATH)/" -e "s/{{docker-machine}}/$($DOCKER_MACHINE)/" \
  > ~/Library/LaunchAgents/com.docker.machine.default.plist

launchctl load ~/Library/LaunchAgents/com.docker.machine.default.plist

if [ $(cat ~/.bash_profile | grep "eval \"\$(docker-machine env default)\"" | wc -l) -eq 1 ]; then
  echo "eval \"\$(docker-machine env default)\"" >> ~/.bash_profile
fi

source ~/.bash_profile
