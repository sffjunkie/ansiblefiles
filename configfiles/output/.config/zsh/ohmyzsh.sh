#!/usr/bin/zsh
export ZSH="${HOME}/.local/oh-my-zsh/"

plugins=(
 git
 web-search
 sudo
 docker
 docker-compose
 zsh-completions
 zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
