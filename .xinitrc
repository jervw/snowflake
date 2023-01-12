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

# start i3

# US-Nordic hybrid keyboard layout
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec i3
