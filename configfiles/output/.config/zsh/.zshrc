CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ -f ${CONFIG_HOME}/sh/env.sh ]] && source ${CONFIG_HOME}/sh/env.sh

mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
HISTFILE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
CASE_SENSITIVE=true
HIST_STAMPS="yyyy-mm-dd"

setopt EMACS
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt AUTOCD
unsetopt BEEP

autoload -U colors && colors

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%s:%b]'
RPROMPT='${vcs_info_msg_0_}'

PS1='%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%(4~|%-1~/…/%2~|%3~)%{$fg[red]%}]%{$reset_color%}$%b '

#: The following lines were added by compinstall
zstyle :compinstall filename "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
autoload -Uz compinit && compinit
# End of lines added by compinstall

source $ZDOTDIR/ohmyzsh.sh

[[ -f ${CONFIG_HOME}/sh/aliases.sh ]] && source ${CONFIG_HOME}/sh/aliases.sh
[[ -f ${CONFIG_HOME}/sh/functions.sh ]] && source ${CONFIG_HOME}/sh/functions.sh
