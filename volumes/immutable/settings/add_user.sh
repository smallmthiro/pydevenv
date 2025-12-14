#!/bin/bash

if [ -z "${1}" ]; then
  exit 1
fi

USERNAME=${1}
DEFAULT_PW="password"

if id "${USERNAME}" &>/dev/null; then
  exit 0
fi

useradd -m -s /bin/bash -G users ${USERNAME}
echo "${USERNAME}:${DEFAULT_PW}" | chpasswd
echo -e "${DEFAULT_PW}\n${DEFAULT_PW}\n" | pdbedit -t -a -u ${USERNAME}

/etc/jupyterhub/immutable_settings/backup_users.sh
