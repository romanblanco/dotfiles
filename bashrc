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

term () {
  tmux has-session -t term &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t term -d
  else
    tmux -2 new-session -A -s term -n server -d 'cd ~/devel/manageiq; bash -i'
    # SKIP_TEST_RESET=true SKIP_AUTOMATE_RESET=true bin/update ;
    # bundle exec rails s -b hostname -p 3000
    tmux new-window  -t term:2 -n worker 'cd ~/devel/manageiq; bash -i '
    # bundle exec rails console ;
    # > enable_console_sql_logging ; simulate_queue_worker
    tmux new-window  -t term:3 -n components 'cd ~/devel/ui-components; bash -i'
    # rm -fr node_modules/ ; rm yarn.lock ; yarn ; yarn build ; yarn start
    tmux split-window 'cd ~/devel/manageiq-ui-classic; bash -i'
    # bin/webpack --watch
    tmux select-window -t term:1
    tmux -2 attach-session -t term
  fi
}

code () {
  tmux has-session -t code &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t code -d
  else
    tmux -2 new-session -A -s code -n manageiq -d 'cd ~/devel/manageiq; bash -i'
    tmux new-window -t code:2 -n classic 'cd ~/devel/manageiq-ui-classic; bash -i '
    tmux new-window -t code:3 -n components 'cd ~/devel/ui-components; bash -i'
    tmux new-window -t code:4 -n content 'cd ~/devel/manageiq-content; bash -i'
    tmux new-window -t code:5 -n console 'cd ~/devel/manageiq; bash -i'
    # bundle exec rails console
    tmux select-window -t code:2
    tmux -2 attach-session -t code
  fi
}

sys () {
  tmux has-session -t sys &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t sys -d
  else
    tmux -2 new-session -A -s sys -n htop -d 'htop'
    tmux new-window -t sys:2 -n openvpn 'cd ~/data/openvpn; bash -i'
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

eval "$(rbenv init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
