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

manageiq () {
  tmux has-session -t manageiq &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t manageiq -d
  else
    tmux -2 new-session -A -s manageiq -n manageiq -d 'cd ~/devel/manageiq; bash -i'
    tmux new-window -t manageiq:2 -n classic 'cd ~/devel/manageiq-ui-classic; bash -i '
    tmux new-window -t manageiq:3 -n components 'cd ~/devel/ui-components; bash -i'
    tmux new-window -t manageiq:4 -n console 'cd ~/devel/manageiq; bash -i'
    # bundle exec rails console
    tmux new-window -t manageiq:5 -n server -d 'cd ~/devel/manageiq; bash -i'
    # SKIP_TEST_RESET=true SKIP_AUTOMATE_RESET=true bin/update ;
    # bundle exec rails s -b hostname -p 3000
    tmux new-window -t manageiq:6 -n worker 'cd ~/devel/manageiq; bash -i '
    # bundle exec rails console ;
    # > enable_console_sql_logging ; simulate_queue_worker
    tmux new-window  -t manageiq:7 -n javascript 'cd ~/devel/ui-components; bash -i'
    # yarn cache clean ; rm -fr node_modules/ ; rm yarn.lock ; yarn ; yarn link ; yarn build ; yarn start
    tmux split-window 'cd ~/devel/manageiq-ui-classic; bash -i'
    # yarn cache clean ; rm -fr node_modules/ ; rm yarn.lock ; rake yarn:clobber ; yarn link @manageiq/ui-components ; bin/update ; bin/webpack --watch
    tmux select-window -t manageiq:2
    tmux -2 attach-session -t manageiq
  fi
}

galaxy () {
  tmux has-session -t ansible &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t ansible -d
  else
    # sudo systemctl start docker ; docker ps ; sudo systemctl stop postgresql # port 5432
    GALAXY_WINDOW_INIT='echo -e \"git submodule update --init --remote\ncd pulp_ansible/ && git checkout 0.2.0b3 && cd ..\ncd pulp_ansible/ && git checkout 0.2.0b3 && cd ..\nmake docker/run-migrations\nmake docker/up\nmake docker/logs\"'
    API_WINDOW_INIT='echo -e \"      \"'
    HUB_WINDOW_INIT='echo -e \"npm install\nnpm run start\"'
    # replace cloud.redhat.com data resource for localhost with local proxy
    PATHS_WINDOW_INIT='echo -e \"sudo SPANDX_CONFIG=./local-frontend-and-api.js bash ~/devel/insights-proxy/scripts/run.sh\"'
    # data replacing cloud.redhat.com data resources
    PROXY_WINDOW_INIT='echo -e \"npm install\nsudo ./update.sh\"'
    tmux -2 new-session -A -s ansible -n galaxy -d "cd ~/devel/galaxy-dev; bash -i -c \"${GALAXY_WINDOW_INIT}\" ; bash -i"
    tmux new-window -t ansible:2 -n api "cd ~/devel/galaxy-api/ ; bash -i"
    tmux new-window -t ansible:3 -n hub "cd ~/devel/ansible-hub-ui/ ; bash -i  -c \"${HUB_WINDOW_INIT}\" ; bash -i"
    tmux new-window -t ansible:4 -n paths "cd ~/devel/ansible-hub-ui/profiles/ ; bash -i -c \"${PATHS_WINDOW_INIT}\" ; bash -i"
    tmux new-window -t ansible:5 -n proxy "cd  ~/devel/insights-proxy/scripts/ ; bash -i -c \"${PROXY_WINDOW_INIT}\" ; bash -i"
    tmux select-window -t ansible:1
    tmux -2 attach-session -t ansible
  fi
}

kafka () {
  tmux has-session -t kafka &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t kafka -d
  else
    tmux -2 new-session -A -s kafka -n zookeeper -d 'cd ~/devel/kafka/kafka/ ; bin/zookeeper-server-start.sh config/zookeeper.properties'
    tmux new-window  -t kafka:2 -n kafka 'cd ~/devel/kafka/kafka/ ; bin/kafka-server-start.sh config/server.properties'
    tmux new-window  -t kafka:3 -n philote 'SECRET=roman LOGLEVEL=debug ~/bin/philote'
    tmux select-window -t kafka:2
    tmux -2 attach-session -t kafka
  fi
}

sys () {
  tmux has-session -t sys &> /dev/null
  if [ $? -eq 0 ] ; then
    tmux -2 attach-session -t sys -d
  else
    tmux -2 new-session -A -s sys -n top -d 'htop'
    tmux new-window -t sys:2 -n alsa 'alsamixer -c 0'
    tmux new-window -t sys:3 -n openvpn 'cd ~/data/openvpn; bash -i -c "echo -e \"sudo openvpn --config redhat.ovpn\"" ; bash -i'
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
