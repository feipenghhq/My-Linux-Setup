#!/usr/bin/sh

#---------------------------
# tmux
#---------------------------
# install Oh-my-tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

#---------------------------
# VIM
#---------------------------
# install Vundle
cd
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sf $PWD/.vimrc ~/.
vim -c "PluginInstall" -c 'qa!' # install vim plugin
