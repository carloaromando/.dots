#!/bin/sh

# Workaround for xkeynail
xhost +SI:localuser:root &

# ALSA
alsactl restore

# Keyboard layout
setxkbmap us &

# xrdb
xrdb -merge ~/.Xresources

# Background
hsetroot -solid '#262729'

# Compton
compton &

# Tilda
tilda &

# Bar
(/home/carlo/scripts/lemonbar | lemonbar -g x18 -p -F#eeeeef -B#111113 -f "Fira Mono"-8 -f FontAwesome-8) &

# Start Emacs Daemon
emacs --daemon &

# Start nightmode script
/home/carlo/scripts/nightmode &

# Start cwm
exec ~/scripts/startcwm
