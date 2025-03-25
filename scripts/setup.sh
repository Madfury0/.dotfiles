#!/bin/bash

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit 1
fi

# Get repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Create symlinks (must come first to ensure configs exist for later steps)
ln -sfv "$REPO_ROOT/configs/vimrc" ~/.vimrc
ln -sfv "$REPO_ROOT/configs/zshrc" ~/.zshrc
ln -sfv "$REPO_ROOT/configs/p10k.zsh" ~/.p10k.zsh

# Install base dependencies
sudo apt update
sudo apt install -y zsh git vim build-essential python3 python3-pip ripgrep clang-format
pip install black autopep8

# Setup ZSH environment first
# Install oh-my-zsh (must come before plugin/theme setup)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k theme (requires oh-my-zsh first)
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
[ -d "$P10K_DIR" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"

# Install zsh-syntax-highlighting (required by your config)
ZSH_SYNTAX_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
[ -d "$ZSH_SYNTAX_DIR" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"

# Install FZF (needs git installed first)
[ -d "$HOME/.fzf" ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-fish >/dev/null

# Setup Vim environment (needs curl installed)
[ -f "$HOME/.vim/autoload/plug.vim" ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

# Install LSP servers (needs python3-pip installed)
pip3 install --user python-lsp-server

# Finalize shell setup (must be last to ensure all zsh components are ready)
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh. Please log out and back in."
fi

echo "Setup complete! All your configs are ready:"
echo "- Vim: ~/.vimrc"
echo "- ZSH: ~/.zshrc with powerlevel10k"
echo "- FZF: Keyboard shortcuts installed"