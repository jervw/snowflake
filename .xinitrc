#!/bin/sh

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# start pipewire
pipewire &
pipewire-pulse &
wireplumber &

# disable caps lock
setxkbmap -option caps:none


# US-Nordic hybrid keyboard layout
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Load Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


# start i3
exec i3
