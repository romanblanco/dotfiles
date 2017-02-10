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
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz)  tar xvzf $1 ;;
      *.tar.xz)  tar xvf $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tar)     tar xf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.bz2)     bunzip2 -k $1 ;;
      *.zip)     unzip $1 ;;
      *.rar)     unrar e $1 ;;
      *.gz)      gunzip -c $1 > `echo $1 | cut -d'.' --complement -f2-` ;;
      *.7z)      7za e $1 ;;
      *.Z)       uncompress $1 ;;
      *)         echo "'$1' cannot be extracted by extract()" ; return 1 ;;
    esac
    return 0
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

term () {
  tmux new-session -s term   -n server -d 'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t term:2 -n worker    'cd ~/devel/manageiq; bash -i '
  tmux new-window  -t term:3 -n console   'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t term:4 -n ssui      'cd ~/devel/manageiq-ui-service; bash -i'
  tmux new-window  -t term:5 -n master    'cd ~/devel/manageiq-master; bash -i'

  tmux select-window -t term:1
  tmux -2 attach-session -t term
}

code () {
  tmux new-session -s code   -n manageiq -d 'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t code:2 -n classic     'cd ~/devel/manageiq/plugins/manageiq-ui-classic; bash -i '
  tmux new-window  -t code:3 -n service     'cd ~/devel/manageiq-ui-service; bash -i'
  tmux new-window  -t code:4 -n components  'cd ~/devel/ui-components; bash -i'

  tmux select-window -t code:1
  tmux -2 attach-session -t code
}

alias diff='diff -s -u --color'
alias df='df -h'
alias cal='cal -m -3'
alias grep='grep --color=auto'
alias egrep='egrep --color'
alias ls='ls --color'

eval "$(rbenv init -)"
