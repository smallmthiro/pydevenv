#!/bin/bash

SMB_DIR="./volumes/mutable/samba"

docker build -t tmp_image -f ./Dockerfile .
docker create --name tmp_container tmp_image jupyterhub --version

JUPYTERHUB_VERSION=$(docker start -i tmp_container)

if [ ! -d ${SMB_DIR} ]; then
  docker cp -a tmp_container:/var/lib/samba ${SMB_DIR}
fi

docker rm -f tmp_container
docker rmi -f tmp_image

docker build -t pydevenv_singleuser \
             --build-arg JUPYTERHUB_VERSION=${JUPYTERHUB_VERSION} \
             -f ./Dockerfile.singleuser .

echo "PYDEVENV_DIR=$(pwd)" > .env.pydevenv_dir
