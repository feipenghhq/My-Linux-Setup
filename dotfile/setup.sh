#!/usr/bin/sh

# tmux
ln -sf $PWD/.tmux.conf ~/.

# VIM
ln -sf $PWD/.vimrc ~/.
vim -c "PluginInstall" -c 'qa!' # install vim plugin
