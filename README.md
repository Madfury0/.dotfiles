# My Dotfiles

Personal configuration files for Linux development environment.

## Features

- Zsh with oh-my-zsh and powerlevel10k
- Vim with LSP support (pylsp and clangd)
- FZF fuzzy finding

## Installation

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git
git clone https://github.com/Madfury0/.dotfiles.git
cd ~/.dotfiles/scripts
chmod +x setup.sh
./setup.sh
```