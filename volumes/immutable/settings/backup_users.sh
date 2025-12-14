#!/bin/bash

backup() {
  local target_file=$1
  local backup_file=$2

  cp -a -f ${target_file} ${backup_file}
}

BACKUP_DIR="/etc/jupyterhub/mutable_settings"

backup /etc/passwd ${BACKUP_DIR}/passwd.bak
backup /etc/shadow ${BACKUP_DIR}/shadow.bak
backup /etc/group ${BACKUP_DIR}/group.bak
backup /etc/gshadow ${BACKUP_DIR}/gshadow.bak
