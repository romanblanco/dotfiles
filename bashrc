shopt -s checkwinsize
[ -z "$PS1" ] && return
[ -f $HOME/.git-completion.bash ] && source $HOME/.git-completion.bash
[ -f $HOME/.git-prompt.sh ] && source $HOME/.git-prompt.sh

__prompt_command () {
  local EXIT="$?"
  if [ $EXIT != 0 ] ; then
    PS1="\[\e[0;31m\]•\[\e[0m\] "
  else
    PS1="\[\e[0;32m\]•\[\e[0m\] "
  fi
  PS1+='\w/$(__git_ps1 " \[\e[0;32m\]%s\[\e[0m\]") '
}

extract () {
  if [ -f $1 ] ; then
    shopt -s nocasematch
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz)  tar xvzf $1 ;;
      *.tar.xz)  tar xvJf $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tar)     tar xf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.bz2)     bunzip2 -k $1 ;;
      *.zip)     unzip $1 ;;
      *.rar)     unrar e $1 ;;
      *.gz)      gunzip -c $1 > `echo $1 | cut -d'.' --complement -f2-` ;;
      *.7z)      7za e $1 ;;
      *.Z)       uncompress $1 ;;
      *)         echo "'$1' cannot be extracted by extract()" ;
                 shopt -u nocasematch ;
                 return 1 ;;
    esac
    shopt -u nocasematch
    return 0
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

sys () {
  tmux has-session -t sys &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t sys -d
  else
    tmux -2 new-session -A -s sys -n top -d 'tmux setw remain-on-exit on ; htop'
    tmux new-window -t sys:2 -n alsa 'tmux setw remain-on-exit on ; alsamixer -c 0 -V all'
    tmux new-window -t sys:3 -n network 'tmux setw remain-on-exit on ; watch nmcli d'
    tmux split-window -h 'tmux setw remain-on-exit on ; watch ss -tupn'
    tmux split-window -v 'tmux setw remain-on-exit on ; bash -i'
    tmux select-pane -t 1
    tmux split-window -v 'tmux setw remain-on-exit on ; ping -D -i 3 -W 2 1.1.1.1'
    tmux new-window -t sys:4 -n hdd 'tmux setw remain-on-exit on ; watch lsblk'
    tmux split-window -h 'tmux setw remain-on-exit on ; watch df -h'
    tmux split-window -v 'tmux setw remain-on-exit on ; ncdu ~/'
    tmux select-pane -t 1
    tmux split-window -v 'tmux setw remain-on-exit on ; mc'
    tmux new-window -t sys:5 -n devctl 'tmux setw remain-on-exit on ; printf "\033]2;%s\033\\" "dmesg - kernel logs" ; dmesg -w'
    tmux split-window -v 'tmux setw remain-on-exit on ; printf "\033]2;%s\033\\" "journalctl - systemd journal" ; journalctl -f'
    tmux split-window -h 'tmux setw remain-on-exit on ; systemctl list-units --user'
    tmux select-window -t sys:1
    tmux -2 attach-session -t sys
  fi
}

alias diff='diff -s -u'
alias df='df -h'
alias cal='cal -m -3'
alias grep='grep --color=auto'
alias egrep='egrep --color'
alias ls='ls --color -h'
alias feh='feh --auto-zoom --scale-down --image-bg "#000000"'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
