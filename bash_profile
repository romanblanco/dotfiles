# user configuration
PATH=""
PATH=$PATH:/bin
PATH=$PATH:/usr/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/sbin
PATH=$PATH:/usr/sbin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/go/bin
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.cargo/bin
PATH=$PATH:$HOME/.pyenv/bin
export PATH
export TERM=screen-256color
export TERMINAL=alacritty
export GOPATH=$HOME/devel/go
export PROMPT_COMMAND='history -a'
export PAGER='less'
export EDITOR='nvim'
export VISUAL='nvim'
export BROWSER='firefox'
export LANG=en_US.UTF-8
export HISTCONTROL=ignoreboth:erasedups
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
tmux has-session -t sys &> /dev/null
if [ $? -ne 0 ] ; then
  sys_session
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] ; then
  exec sway
fi
