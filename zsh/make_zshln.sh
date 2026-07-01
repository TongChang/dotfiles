#!/bin/bash

# ホームディレクトリの指定は、環境変数 $HOME を使うとポータビリティが上がります
# （今回は元のパス構造をベースにしています）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_ZSH="${HOME}/.zshrc"
CONF_ZSH_PATH="${HOME}/.zshrc.path"
CONF_CLONED_ZSH="${SCRIPT_DIR}/_zshrc"

function check_zshrc() {
  # 1. すでに正しいシンボリックリンクが張られているかチェック
  if [ -L "${CONF_ZSH}" ]; then
    local link
    link=$(readlink "${CONF_ZSH}")
    if [ "${link}" = "${CONF_CLONED_ZSH}" ]; then
      echo "Already setting is done."
      exit 0 # 💡 ここで正常終了させることで、後ろのリンク作成処理をスキップします
    fi
  fi

  # 2. 既存のファイル（実体 or 別のリンク）がある場合はバックアップ
  if [ -e "${CONF_ZSH}" ] || [ -L "${CONF_ZSH}" ]; then
    backup_zshrc
  fi
}

function backup_zshrc() {
  if [ ! -e "${CONF_ZSH}_origin" ]; then
    mv "${CONF_ZSH}" "${CONF_ZSH}_origin"
    echo "Backup created: ${CONF_ZSH}_origin"
  else
    echo "Error: Backup failed." >&2
    echo "${CONF_ZSH}_origin already exists. Please check it." >&2
    exit 99
  fi
}

function make_zshrc_link() {
  # シンボリックリンクの作成
  ln -s "${CONF_CLONED_ZSH}" "${CONF_ZSH}"
  echo "Created symbolic link: ${CONF_ZSH} -> ${CONF_CLONED_ZSH}"

  # .zshrc.path がなければ作成
  if [ ! -e "${CONF_ZSH_PATH}" ]; then
    touch "${CONF_ZSH_PATH}"
    echo "Created file: ${CONF_ZSH_PATH}"
  fi
}

# --- Main ---------------------------------------------
check_zshrc
make_zshrc_link
