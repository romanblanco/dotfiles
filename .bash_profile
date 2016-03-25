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
export PATH
export TERM=rxvt-unicode-256color
export TERMINAL=urxvt256c
export PROMPT_COMMAND='history -a'
export PAGER='less'
export EDITOR='vim'
export VISUAL='vim'
export BROWSER='firefox'
export LANG=en_US.UTF-8
export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoredups
export PROMPT_COMMAND=__prompt_command
unset HISTSIZE
unset HISTFILESIZE
shopt -s histappend

eval `ssh-agent -s` &> /dev/null
ssh_files=(~/.ssh/*)
for identification in ${ssh_files[@]} ; do
  ssh-add ${identification%.*} &> /dev/null
done

source $HOME/.bashrc
