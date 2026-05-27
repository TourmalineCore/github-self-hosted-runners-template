#!/bin/bash

cd /home/runner/actions-runner || exit

# Cleanup docker dirs because docker fails to start if they haven`t been cleaned up after restart
sudo rm -f /var/run/docker.pid
sudo rm -rf /var/run/docker

./config.sh --url https://github.com/${REPOSITORY_OWNER} --token ${REG_TOKEN} --runnergroup $RUNNER_GROUP --labels $LABELS

sudo /usr/local/bin/dind dockerd --log-level=error &

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!