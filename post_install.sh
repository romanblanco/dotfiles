#!/bin/bash

USER_NAME=`who | awk '{print $1}'`
USER_HOME=/home/$USER_NAME

# rbenv
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

# fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  $USER_HOME/.fzf/install

# dotfiles
  rm .ssh -r
  rm .bash_profile .bashrc
  mkdir .ssh .config .config/i3 .config/nvim
  ruby install_dotfiles.rb

# systemd
  systemctl --user enable redshift.service
  systemctl --user start redshift.service
  systemctl --user enable ipfs.service
  systemctl --user start ipfs.service
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service
  systemctl --user enable finance.service
  systemctl --user start finance.service

# git-prompt and completion
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
  chmod +x .git-prompt.sh
  chmod +x .git-completion.bash

# neobundle
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  nvim +NeoBundleInstall +qall

mkdir $USER_HOME/etc $USER_HOME/tmp $USER_HOME/devel $USER_HOME/bin $USER_HOME/data
chown $USER_NAME:$USER_NAME -R etc tmp devel bin data .*
chmod 600 .ssh/config

cd bin
git clone https://aur.archlinux.org/epson-inkjet-printer-escpr.git
git clone https://aur.archlinux.org/imagescan-plugin-networkscan.git
git clone https://aur.archlinux.org/spotify.git
cd epson-inkjet-printer-escpr/
makepkg -isr
cd ..
cd imagescan-plugin-networkscan/
makepkg -isr
cd ..
cd spotify
makepkg -isr
cd ..

exit 0
