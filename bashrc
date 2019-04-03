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
  tmux -2 new-session -s term   -n server -d  'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t term:2 -n worker        'cd ~/devel/manageiq; bash -i '
  tmux new-window  -t term:3 -n components    'cd ~/devel/ui-components; bash -i'
  tmux new-window  -t term:4 -n service       'cd ~/devel/manageiq-ui-service; bash -i'
  tmux select-window -t term:1
  tmux -2 attach-session -t term
}

code () {
  tmux -2 new-session -s code   -n manageiq -d 'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t code:2 -n classic        'cd ~/devel/manageiq-ui-classic; bash -i '
  tmux new-window  -t code:3 -n components     'cd ~/devel/ui-components; bash -i'
  tmux new-window  -t code:4 -n service        'cd ~/devel/manageiq-ui-service; bash -i'
  tmux new-window  -t code:5 -n console        'cd ~/devel/manageiq; bash -i'
  tmux select-window -t code:2
  tmux -2 attach-session -t code
}

alias diff='diff -s -u'
alias df='df -h'
alias cal='cal -m -3'
alias grep='grep --color=auto'
alias egrep='egrep --color'
alias ls='ls --color'
alias git='hub'

eval "$(rbenv init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
