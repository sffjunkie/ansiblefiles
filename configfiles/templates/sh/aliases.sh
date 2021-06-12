#!/bin/sh
# Verbosity and settings that you pretty much just always are going to want.
alias \
	bat="cat /sys/class/power_supply/BAT?/capacity" \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -v" \
	mkd="mkdir -pv" \
	yt="youtube-dl --add-metadata -i" \
	yta="yt -x -f bestaudio/best" \
	ffmpeg="ffmpeg -hide_banner"

# Colorize commands when possible.
alias \
	ls="exa --group-directories-first" \
	ll="exa -l" \
	la="exa -a" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi"\
	tree="exa --tree --color=always"

# These common commands are just too long! Abbreviate them.
alias \
	ka="killall" \
	trem="transmission-remote" \
	YT="youtube-viewer" \
	sdn="sudo shutdown -h now" \
	f="$FILE" \
	e="$EDITOR" \
	v="$EDITOR" \
	p="sudo pacman" \
	xi="sudo xbps-install" \
	xr="sudo xbps-remove -R" \
	xq="xbps-query" \
        nano="nano -c"

# Some other stuff
alias \
	vim="$EDITOR" \
	magit="nvim -c MagitOnly" \
	ref="shortcuts >/dev/null; source ${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc ; source ${XDG_CONFIG_HOME:-$HOME/.config}/zshnameddirrc" \
	weath="less -S ${XDG_DATA_HOME:-$HOME/.local/share}/weatherreport" \
	tmux="tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

# Added for alacritty.
# Set the TERM variable before ssh'ing instead of copying over alacritty terminfo definition
alias \
	ssh='env TERM=xterm-256color ssh -t'

alias \
    ping='ping -c 4'

# Git aliases
alias \
	g="git" \
	gs='git status'

alias \
    config="/usr/bin/git --git-dir=${XDG_DATA_HOME:-$HOME/.local/share}/config.git/ --work-tree=$HOME"

alias plexamp='Plexamp.AppImage --disable-seccomp-filter-sandbox'
