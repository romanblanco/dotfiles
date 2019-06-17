# do not blank screen after inactivity
[[ ! -z "$DISPLAY" ]] && xset s off -dpms

# user configuration

PATH=""
PATH=$PATH:/bin
PATH=$PATH:/usr/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/sbin
PATH=$PATH:/usr/sbin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/.rbenv/bin
PATH=$PATH:$HOME/.cargo/bin
export PATH
export TERM=screen-256color
export TERMINAL=alacritty
export PROMPT_COMMAND='history -a'
export PAGER='less'
export EDITOR='vim'
export VISUAL='vim'
export BROWSER='firefox'
export LANG=en_US.UTF-8
export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoredups
export HISTSIZE=-1
export HISTFILESIZE=-1
export PROMPT_COMMAND=__prompt_command
shopt -s histappend

eval `ssh-agent -s` &> /dev/null
ssh_files=($HOME/.ssh/*)
for identification in ${ssh_files[@]} ; do
  ssh-add ${identification%.*} &> /dev/null
done

source $HOME/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] ; then
  startx
fi
