#!/bin/bash

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit 1
fi

# Get repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Create symlinks
ln -sfv "$REPO_ROOT/configs/vimrc" ~/.vimrc
# Add other config files here if needed, e.g.:
# ln -sfv "$REPO_ROOT/configs/zshrc" ~/.zshrc

# Install dependencies
sudo apt update
sudo apt install -y zsh git vim build-essential python3 python3-pip ripgrep clang-format

pip install black autopep8

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Install FZF
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish >/dev/null
fi

# Install vim-plug and plugins
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

# Install LSP servers
pip3 install --user python-lsp-server

# Set default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh. Please log out and back in."
fi

echo "Setup complete!"
