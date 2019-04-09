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

code () {
  tmux -2 new-session -A -s code -n code -d   'cd ~/devel; bash -i'
  tmux -2 attach-session -t code
}

sys () {
  tmux -2 new-session -A -s sys -n top -d 'htop'
  tmux new-window -t sys:2 -n ipfs  'ipfs daemon'
  tmux new-window -t sys:3 -n graffiti 'cd ~/devel/graffiti ; bundle exec ruby map.rb -o 0.0.0.0'
  tmux select-window -t sys:1
  tmux -2 attach-session -t sys
}

alias diff='diff -s -u'
alias df='df'
alias cal='cal -m -3'
alias grep='grep --color=auto'
alias egrep='egrep --color'
alias ls='ls --color'
alias feh='feh --auto-zoom --scale-down --image-bg "#000000"'

eval "$(rbenv init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
