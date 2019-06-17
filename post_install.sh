#!/bin/bash

USER_NAME=`who | grep 'tty1' | awk '{print $1}'`
USER_HOME=/home/$USER_NAME

# TODO basic packages

# fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $USER_HOME/.fzf
  $USER_HOME/.fzf/install

# dotfiles
  rm .ssh -r  # FIXME: nofirst
  rm .bash_profile .bashrc
  mkdir .ssh .config .config/alacritty .config/nvim .config/redshift .config/sway .config/sway .config/systemd .config/systemd/user
  ruby install.rb

# systemd
  systemctl --user enable redshift.service
  systemctl --user start redshift.service
  systemctl --user enable ipfs.service
  systemctl --user start ipfs.service
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service

# git-prompt and completion
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
  chmod +x .git-prompt.sh
  chmod +x .git-completion.bash

# neobundle
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  nvim +NeoBundleInstall +qall

mkdir $USER_HOME/etc $USER_HOME/tmp $USER_HOME/devel $USER_HOME/bin $USER_HOME/data
chown $USER_NAME -R etc tmp devel bin data .*
chmod 600 .ssh/config
chmod +x .config/sway/lock.sh

exit 0
