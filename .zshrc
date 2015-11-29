ZSH=$HOME/.oh-my-zsh
UPDATE_ZSH_DAYS=14
HIST_STAMPS="dd.mm.yyyy"
ZSH_THEME="lambda"
plugins=(fedora git ruby rails rbenv gem bundler rake python pep8 pip tmux \
         sudo history zsh_reload)
source $ZSH/oh-my-zsh.sh

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

alias diff='diff -s'
alias df='df -h'
alias cal='cal -m -3'

eval "$(rbenv init -)"
