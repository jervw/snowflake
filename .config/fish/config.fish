if status is-interactive
    # Commands to run in interactive sessions can go here
end

 function fish_right_prompt
  #intentionally left blank
 end
 
 function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

#k# Start X at login
#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end

function twitch
    kill -9 $(ps -o ppid -p $fish_pid)
    nohup streamlink -p mpv --quiet --twitch-low-latency twitch.tv/"$argv" best &
    nohup chatterino -c "$argv" &> /dev/null 
end

# aliases
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias vim="nvim"
alias nano="nvim"
alias ocat="/usr/bin/cat"
alias cat="bat"
alias code="/sbin/vscodium"

export FrameworkPathOverride=/lib/mono/4.5

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
