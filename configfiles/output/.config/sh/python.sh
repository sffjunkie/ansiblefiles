#!/bin/sh
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=${DEV_HOME:-$HOME/development}/venvs
export PROJECT_HOME=${DEV_HOME:-$HOME/development}/projects
source ${HOME}/.local/bin/virtualenvwrapper.sh

if [[ -z "${WSLENV}" ]]; then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi
