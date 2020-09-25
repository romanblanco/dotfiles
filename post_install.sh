#!/bin/bash

USER_NAME=`who | grep 'tty1' | awk '{print $1}'`
USER_HOME=/home/$USER_NAME

# basic packages
pacman -S xorg-server-xwayland xorg-xev sway swaylock swayidle i3status alacritty gammastep ttf-jetbrains-mono ttf-dejavu brightnessctl
pacman -S slurp wf-recorder grim wl-clipboard
pacman -S alsa-utils pulseaudio pulseaudio-alsa vlc feh
pacman -S man wget curl macchanger openssh iproute2 net-tools docker docker-compose
pacman -S tar zip unzip p7zip unrar
pacman -S tmux ctags htop bmon tig neovim git emacs ripgrep mc ncdu neofetch kmon tree ruby
pacman -S firefox firefox-developer-edition chromium keepassxc okular libreoffice

# systemd
systemctl enable docker
systemctl start docker
systemctl enable sshd
systemctl start sshd

# systemd --user
systemctl --user enable redshift.service
systemctl --user start redshift.service

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $USER_HOME/.fzf
$USER_HOME/.fzf/install

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# dotfiles
rm .ssh -r # FIXME: not on the first run
rm .bash_profile .bashrc
mkdir .ssh .config .config/alacritty .config/nvim .config/redshift .config/sway .config/systemd .config/systemd/user
ruby install_dotfiles.rb

# git-prompt and completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash
chmod +x .git-prompt.sh
chmod +x .git-completion.bash

# neobundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
nvim +NeoBundleInstall +qall

# spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

mkdir $USER_HOME/etc $USER_HOME/tmp $USER_HOME/devel $USER_HOME/bin
chown $USER_NAME -R etc tmp devel bin .*
chmod 600 .ssh/config
chmod +x .config/sway/lock.sh

exit 0
