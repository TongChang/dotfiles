#!/bin/sh

CONF_ZSH=/home/.zshrc
CONF_ZSH_PATH=/home/.zshrc.path
CONF_CLONED_ZSH=/home/dotfiles/zsh/_zshrc

function check_zshrc() {
  # link check
  if [ -L ${CONF_ZSH} ]; then
    # link path check
    link=`readlink ${CONF_ZSH}`
    if [ ${link} == ${CONF_CLONED_ZSH} ]; then
      echo "already setting is done."
    else
      # when link to other file
      backup_zshrc
    fi
  else
    # exist check
    if [ -e ${CONF_ZSH} ]; then  
      # when isnt link.
      backup_zshrc
    fi 
  fi
}

function backup_zshrc() {
  # backup .zshrc
  if [ ! -e ${CONF_ZSH}_origin ]; then
    mv ${CONF_ZSH} ${CONF_ZSH}_origin
  else
    echo "backup failed."
    echo "${CONF_ZSH}_origin is already exist."
    echo "please check it."
    exit 99
  fi
}

function make_zshrc_link() {
  # create .zshrc symbolic link
  ln -s ${CONF_CLONED_ZSH} ${CONF_ZSH}
  echo "create ${CONF_ZSH}"

  # if does't exist .zshrc.path create the file
  if [ ! -e ${CONF_ZSH_PATH} ]; then
    touch ${CONF_ZSH_PATH}
    echo "create ${CONF_ZSH_PATH}"
  fi
}

# main
check_zshrc
make_zshrc_link

