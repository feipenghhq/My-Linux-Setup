# Ubuntu setup

## Install Basic Tools

### Basics

```bash
sudo apt install git                # git
sudo apt install vim-gtk3           # vim
sudo apt install tmux               # tmux
sudo snap install code --classic    # vscode
sudo apt  install universal-ctags   # ctags
```

### Oh-my-bash

```bash
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
```

### Oh-my-tmux

```bash
cd ~
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
```

## Environment Setup

### SSH and GITHUB

```bash
cd ~
ssh-keygen

```
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

### Setup Git Config

```bash
git config --global user.name "Your Name"
git config --global user.email "youremail@yourdomain.com"
git config --global core.editor vim
git config --global color.ui true
```
### Download the My-Linux-Setup repo

```bash
cd ~
git clone git@github.com:feipenghhq/My-Linux-Setup.git
```

### Setup VIM

```bash
cd ~
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sf My-Linux-Setup/dotfile/.vimrc ~/.
vim -c "PluginInstall" -c 'qa!' # install vim plugin
```
