## ZSH CONFIG ##

export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8

ZSH_THEME="gitster"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
source $ZSH/oh-my-zsh.sh
source $HOME/.zshalias

## keychain stuff
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
mkdir -p "$HOME"/.local/share/keyrings


export PATH="$PATH:$HOME/.spicetify"



