#!/bin/bash

JUPYTERHUB_PID=0
SHARE_DIR="/share"

cleanup() {
  if ps -p ${JUPYTERHUB_PID} > /dev/null 2>&1; then
    kill -SIGTERM ${JUPYTERHUB_PID}
    wait ${JUPYTERHUB_PID}
    echo "PYDEVENV: Killed jupyterhub"
  fi

  service ssh stop
  service smbd stop

  echo "PYDEVENV: Backup users"
  /etc/jupyterhub/immutable_settings/backup_users.sh
}

if [ -z ${PYDEVENV_DIR} ]; then
  echo 'PYDEVENV: Please run "setup_pydevenv.sh" to set the environment variable "PYDEVENV_DIR".'
  exit -1
fi

if [ ! -d ${SHARE_DIR} ]; then
  mkdir ${SHARE_DIR}
fi
chown :users ${SHARE_DIR}
chmod 2775 ${SHARE_DIR}

echo "PYDEVENV: Restore users"
/etc/jupyterhub/immutable_settings/restore_users.sh

trap 'cleanup' SIGHUP SIGINT SIGQUIT SIGTERM

service smbd restart
service ssh restart

jupyterhub -f /etc/jupyterhub/immutable_settings/jupyterhub_config.py &
JUPYTERHUB_PID=$!

wait ${JUPYTERHUB_PID}

cleanup

echo "PYDEVENV: Done!"
