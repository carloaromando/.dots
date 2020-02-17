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
hsetroot -solid '#414F61'

# Compton
# compton &

# Bar
#(/home/carlo/scripts/bar | lemonbar -g x18 -p -F#eeeeef -B#111113 -f "Iosevka Term SS09 Semibold"-8 -f FontAwesome-8) &

# source .Xmodmap (switch esc to caps lock)
sleep 5 && xmodmap ~/.Xmodmap &

# Start Emacs Daemon
emacs --daemon &

# Start URxvt daemon
urxvtd -q -f -o

# Start nightmode script
# /home/carlo/scripts/nightmode &

# Force color temperature to reduce blue light
sleep 5 && sct 5000 &

# xbanish
sleep 5 && xbanish &

# Start cwm
exec ~/scripts/startcwm
