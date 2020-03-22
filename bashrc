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
      *.kmz)     unzip $1 ;;
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

sys_session () {
  remain="tmux setw remain-on-exit on"
  watch_cmd="watch --no-title --beep --color --interval 5"
  window_name="printf '\033]2;%s\033\\'"
  # top
  tmux -2 new-session -A -s sys -n top -d "${remain} ; htop"
  # sound
  tmux new-window -t sys:2 -n sound "${remain} ; alsamixer --card 0 --view all"
  # 3: network
  tmux new-window -t sys:3 -n network "${remain} ; ${watch_cmd} nmcli d"
  tmux split-window -h "${remain} ; ${watch_cmd} netstat -tupn"
  tmux split-window -v "${remain} ; bash -i"
  tmux select-pane -t 1
  tmux split-window -v "${remain} ; ping -D -i 3 -W 2 1.1.1.1"
  # 4: hdd
  tmux new-window -t sys:4 -n hdd "${remain} ; ${watch_cmd} lsblk"
  tmux split-window -h "${remain} ; ${watch_cmd} df -h"
  tmux split-window -v "${remain} ; ncdu ~/"
  tmux select-pane -t 1
  tmux split-window -v "${remain} ; mc"
  # 5: devctl
  tmux new-window -t sys:5 -n devctl "${remain} ; ${window_name} 'dmesg - kernel logs' ; dmesg --follow"
  tmux split-window -v "${remain} ; ${window_name} 'journalctl - systemd journal' ; journalctl --follow"
  tmux split-window -h "${remain} ; systemctl list-units --user"
  # 6: prompt
  tmux new-window -t sys:6 -n prompt "${remain} ; bash -c \'neofetch\' -i ; bash -i"
  tmux select-window -t sys:6
}

sys () {
  tmux has-session -t sys &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t sys -d
  else
    sys_session
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

eval "$(rbenv init -)"
