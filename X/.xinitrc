#!/bin/sh

# ALSA
alsactl restore

# Keyboard layout
setxkbmap us &

# xrdb
xrdb -merge ~/.Xresources

# Background
hsetroot -solid '#5E6975'

# source .Xmodmap (switch esc to caps lock)
sleep 5 && xmodmap ~/.Xmodmap &

# increase speed of scrolling for kensington expert trackball
xinput set-prop 10 'libinput Accel Speed' 1

# Start Emacs Daemon
emacs --daemon &

# Start URxvt daemon
urxvtd -q -f -o

# Start nightwatch daemon
nightwatch &

# Start xbindkeys
xbindkeys &

# xbanish
sleep 5 && xbanish &

# Start cwm
exec ~/scripts/startcwm
