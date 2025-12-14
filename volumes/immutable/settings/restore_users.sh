#!/bin/bash

restore() {
  local backup_file=$1
  local target_file=$2

  if [ -e ${backup_file} ]; then
    cp -a -f ${backup_file} ${target_file}
  fi
}

BACKUP_DIR="/etc/jupyterhub/mutable_settings"

restore ${BACKUP_DIR}/passwd.bak /etc/passwd
restore ${BACKUP_DIR}/shadow.bak /etc/shadow
restore ${BACKUP_DIR}/group.bak /etc/group
restore ${BACKUP_DIR}/gshadow.bak /etc/gshadow
