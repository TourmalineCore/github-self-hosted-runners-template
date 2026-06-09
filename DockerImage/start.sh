#!/bin/bash

cd /home/runner/actions-runner || exit

./config.sh --url https://github.com/${REPOSITORY_OWNER} --token ${REG_TOKEN} --runnergroup $RUNNER_GROUP --labels $LABELS

# Получаем ID группы, которой принадлежит файл
export DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

# Проверяем, существует ли группа
if getent group "${DOCKER_GID}" >/dev/null; then
  # Сразу добавляем пользователя в группу, потому что она уже создана
  export DOCKER_GNAME=$(stat -c '%G' /var/run/docker.sock)
  sudo usermod -aG ${DOCKER_GNAME} runner  
else
  # Создаем группу, если ее еще нет и добавляем в нее пользователя
  sudo groupadd -g ${DOCKER_GID} docker
  sudo usermod -aG docker runner
fi

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup' TERM 

./run.sh & wait $!