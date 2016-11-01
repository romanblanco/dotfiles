#!/bin/bash

USER_NAME=`who | awk '{print $1}'`
HOME=/home/$USER_NAME

# basic packages
  dnf -y check-update
  dnf -y upgrade
  dnf -y install \
    vim ctags tig \
    gcc gcc-c++ cmake make \
    tar unzip p7zip ncompress \
    htop alsa-utils alsa-lib sudo scrot the_silver_searcher curl wget tmux \
    mesa-vdpau-drivers xbacklight redshift i3 i3status i3lock rxvt-unicode-256color \
    network-manager-applet \
    python python3 python-devel python-pip python3-pip \
    ruby gem openssl-devel readline-devel zlib-devel \
    fuse fuse-ntfs-3g dkms gparted \
    texlive-collection-langczechslovak texlive texlive-latex texlive-xetex texlive-graphicx-psmin ImageMagick \
    texlive-blindtext texlive-appendix \
    kernel-modules-extra \
  # rpmfusion repo (vlc, steam)
  dnf -y install dnf-plugins-core
  dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                              http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  dnf -y install vlc
  # copr repo (telegram, xrectsel)
  dnf -y copr enable rommon/telegram
  dnf -y copr enable stbenjam/xrectsel
  dnf -y install xrectsel byzanz telegram-desktop
  # negativo17 repo (spotify)
  dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
  dnf -y install spotify-client

# rbenv
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

# dotfiles
  rm .ssh -r
  cd etc
  FILES=("`ls -A`")
  IGNORED=(".git" ".gitignore" "screenshot.png" "README.md" "LICENSE" "`basename $0`")
  for file in ${FILES[@]/$IGNORED} ; do
    ln -s `pwd`/$file ../$file &> /dev/null
    if [[ $? -ne 0 ]]
    then
      rm ../$file
      ln -s `pwd`/$file ../$file
    fi
  done
  cd ..

# git-prompt and completion
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
  chmod +x .git-prompt.sh
  chmod +x .git-completion.bash

# neobundle
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  vim +NeoBundleInstall +qall

# font
  wget https://github.com/andreberg/Meslo-Font/blob/master/dist/v1.2.1/Meslo%20LG%20DZ%20v1.2.1.zip?raw=true -O fonts.zip
  unzip fonts.zip -d fonts
  mkdir .fonts
  mv fonts/Meslo\ LG\ DZ\ v1.2.1/MesloLGSDZ-Regular.ttf .fonts
  rm -fr fonts fonts.zip

rm -r Desktop Documents Music Pictures Public Templates Videos
mkdir tmp devel

chown $USER_NAME:$USER_NAME -R etc tmp devel .*
chmod 600 .ssh/config

git config --global core.excludesfile .gitignore
git config --global core.editor vim

exit 0
