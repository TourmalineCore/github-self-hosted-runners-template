#!/bin/bash

cd /home/runner/actions-runner || exit

# Cleanup docker dirs because docker fails to start if they haven`t been cleaned up after restart
sudo rm -f /var/run/docker.pid
sudo rm -rf /var/run/docker

./config.sh --url https://github.com/${REPOSITORY_OWNER} --token ${REG_TOKEN} --runnergroup $RUNNER_GROUP --labels $LABELS

# Start docker daemon using Docker in Docker
sudo /usr/local/bin/dind dockerd --log-level=error &

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup' TERM 

# Ctart runner
./run.sh & wait $!
