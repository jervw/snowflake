function fish_right_prompt
    # intentionally left blank
end

function doas
    if test "$argv" = !!
        eval command doas $history[1]
    else
        command doas $argv
    end
end

function sudo
    if test "$argv" = !!
        eval command doas $history[1]
    else
        command doas $argv
    end
end

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

function twitch
    kill -9 $(ps -o ppid -p $fish_pid)
    nohup streamlink -p mpv --twitch-api-header --quiet --twitch-low-latency twitch.tv/"$argv" best &
    nohup chatterino -c "$argv" &>/dev/null
end

# aliases
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias vim="nvim"
alias nano="nvim"
alias ocat="/usr/bin/cat"
alias cat="bat"
alias whereami="curl ipinfo.io/city"
alias emacs="emacsclient -n -c -a emacs"
