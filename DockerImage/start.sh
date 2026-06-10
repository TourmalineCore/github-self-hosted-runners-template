#!/bin/bash

cd /home/runner/actions-runner || exit

./config.sh --url https://github.com/${REPOSITORY_OWNER} --token ${REG_TOKEN} --runnergroup $RUNNER_GROUP --labels $LABELS

# Get the ID of the group to which the file belongs
export DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

# Checking if a group exists
if getent group "${DOCKER_GID}" >/dev/null; then
  # Adding a user to the group because it has already been created
  export DOCKER_GNAME=$(stat -c '%G' /var/run/docker.sock)
  sudo usermod -aG ${DOCKER_GNAME} runner  
else
  # Create a group if one doesn't already exist, and add the user to it
  sudo groupadd -g ${DOCKER_GID} docker
  sudo usermod -aG docker runner
fi

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup' TERM 

sudo -E -u runner bash -c ./run.sh & wait $!
