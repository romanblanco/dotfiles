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

galaxy () {
  tmux has-session -t ansible &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t ansible -d
  else
    # sudo systemctl start docker ; docker ps ; sudo systemctl stop postgresql # port 5432
    GALAXY_WINDOW_INIT='echo -e \"git submodule update --init --remote\ncd pulp_ansible/ && git checkout e8a9176cef73 && cd ..\nmake docker/run-migrations\nmake docker/up\nmake docker/logs\"'
    HUB_WINDOW_INIT='echo -e \"npm install\nnpm run start\"'
    # replace cloud.redhat.com data resource for localhost with local proxy
    PATHS_WINDOW_INIT='echo -e \"sudo SPANDX_CONFIG=./local-frontend-and-api.js bash ~/devel/insights-proxy/scripts/run.sh\"'
    # data replacing cloud.redhat.com data resources
    PROXY_WINDOW_INIT='echo -e \"npm install\nsudo ./update.sh\"'
    tmux -2 new-session -A -s ansible -n galaxy -d "cd ~/devel/galaxy-dev; bash -i -c \"${GALAXY_WINDOW_INIT}\" ; bash -i"
    tmux new-window -t ansible:2 -n api "cd ~/devel/galaxy-dev/galaxy-api/ ; bash -i"
    tmux new-window -t ansible:3 -n hub "cd ~/devel/ansible-hub-ui/ ; bash -i  -c \"${HUB_WINDOW_INIT}\" ; bash -i"
    tmux split-window 'cd ~/devel/ansible-hub-ui/ ; bash -i'
    tmux new-window -t ansible:4 -n paths "cd ~/devel/ansible-hub-ui/profiles/ ; bash -i -c \"${PATHS_WINDOW_INIT}\" ; bash -i"
    tmux new-window -t ansible:5 -n proxy "cd  ~/devel/insights-proxy/scripts/ ; bash -i -c \"${PROXY_WINDOW_INIT}\" ; bash -i"
    tmux select-window -t ansible:1
    tmux -2 attach-session -t ansible
  fi
}

sys () {
  tmux has-session -t sys &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t sys -d
  else
    tmux -2 new-session -A -s sys -n top -d 'tmux setw remain-on-exit on ; htop'
    tmux new-window -t sys:2 -n alsa 'tmux setw remain-on-exit on ; alsamixer -c 0'
    tmux new-window -t sys:3 -n openvpn 'cd ~/data/openvpn; bash -i -c "echo -e \"sudo openvpn --config redhat.ovpn\"" ; bash -i'
    tmux split-window -v 'tmux setw remain-on-exit on ; watch nmcli'
    tmux split-window -h 'bash -i'
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

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
