#!/bin/bash

USER_NAME=`who | awk '{print $1}'`
HOME=/home/$USER_NAME

# TODO basic packages

# fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  $HOME/.fzf/install

# dotfiles
  rm .ssh -r
  rm .bash_profile .bashrc
  mkdir .ssh .config/nvim .config/sway
  ruby install.rb

# git-prompt and completion
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
  chmod +x .git-prompt.sh
  chmod +x .git-completion.bash

# neobundle
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  nvim +NeoBundleInstall +qall

chown $USER_NAME -R etc tmp devel bin data .*
chmod 600 .ssh/config
chmod +x .config/sway/lock.sh

exit 0
