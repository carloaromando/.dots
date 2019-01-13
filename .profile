#!/bin/sh

PATH="$HOME/bin:$PATH:$HOME/.cargo/bin:$HOME/scripts"
PS1='\$ '
export PATH PS1

alias ll='ls -lahFN --color=auto'
alias vi='vim'
alias em='emacsclient'
alias zi='doas -n zile'
alias xa='doas -n xbps-install'
alias xu='doas -n xbps-install -Syu'
alias xq='doas -n xbps-query -R -s'
alias xr='doas -n xbps-remove'
alias shut='doas shutdown -h now'
alias reboot='doas reboot'
alias lib?='ldconfig -p | grep'
alias draw='gromit-mpx'

start_tmux() {
  if ! tmux new-session -As 0 -n "$1" "cd $2 && $3" 2>/dev/null;then
    if tmux select-window -t "$1" 2>/dev/null;then
      if tmux list-windows|grep ": ${1}\\*">/dev/null;then cd "$2"||return;fi
    else
      if tmux show-window-option automatic-rename|grep off>/dev/null;then
        tmux new-window -n "$1" -c "$2" sh -c "$3"
      else
        tmux rename-window "$1" && cd "$2" && sh -c "$3"
      fi
    fi
  fi
}

export JAVA_HOME=/usr/lib/jvm/openjdk-1.8.0_202/
export RUST_SRC_PATH=${HOME}/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
