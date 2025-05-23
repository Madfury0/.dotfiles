#!/bin/bash

# Prevent running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: This script should not be run as root!" >&2
    exit 1
fi

echo "Setting up Madfury's environment"

# Get repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

dir="~/.vim/snippets"
dir=$(eval echo $dir)

if [ ! -d "$dir" ]; then
  mkdir -p "$dir"
fi

touch "$dir/c.json" "$dir/cpp.json" "$dir/python.json"


# Install base dependencies
sudo apt install -y zsh git vim build-essential python3 python3-pip ripgrep clang-format tmux clangd python3-venv pipx

# sudo apt install gcc-arm-none-eabi

# Install pylsp and all required tools
pipx install "python-lsp-server[all]"
pipx ensurepath

# Setup ZSH environment first
# Install oh-my-zshell
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k theme
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
[ -d "$P10K_DIR" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"

# Install zsh-syntax-highlighting
ZSH_SYNTAX_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
[ -d "$ZSH_SYNTAX_DIR" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"

# Install zsh-autosuggestions
ZSH_AUTOSUGGESTIONS_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
[ -d "$ZSH_AUTOSUGGESTIONS_DIR" ] || git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_DIR"

# Create symlinks
ln -sfv "$REPO_ROOT/configs/vimrc" ~/.vimrc
ln -sfv "$REPO_ROOT/configs/zshrc" ~/.zshrc
ln -sfv "$REPO_ROOT/configs/p10k.zsh" ~/.p10k.zsh
ln -sfv "$REPO_ROOT/vim/snippets/c.json" ~/.vim/snippets/c.json
ln -sfv "$REPO_ROOT/vim/snippets/cpp.json" ~/.vim/snippets/cpp.json
ln -sfv "$REPO_ROOT/vim/snippets/python.json" ~/.vim/snippets/python.json


# Install FZF (needs git installed first)
[ -d "$HOME/.fzf" ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-fish >/dev/null

# Setup Vim environment (needs curl installed)
[ -f "$HOME/.vim/autoload/plug.vim" ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"
 

# Finalize shell setup (must be last to ensure all zsh components are ready)
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh."
    exec zsh
fi

echo "Setup complete! All your configs are ready:"
