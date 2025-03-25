#!/bin/bash

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit 1
fi


# Create symlinks with backup
backup_if_exists ~/.vimrc
ln -sfv "$REPO_ROOT/configs/vimrc" ~/.vimrc

backup_if_exists ~/.zshrc
ln -sfv "$REPO_ROOT/configs/zshrc" ~/.zshrc

backup_if_exists ~/.p10k.zsh
ln -sfv "$REPO_ROOT/configs/p10k.zsh" ~/.p10k.zsh

# Install dependencies
sudo apt update
sudo apt install -y zsh git vim build-essential python3 python3-pip ripgrep clang-format

pip3 install black autopep8

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Install zsh-syntax-highlighting
ZSH_SYNTAX_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
if [ ! -d "$ZSH_SYNTAX_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
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

# Configure ZSH
if [ -f ~/.zshrc ]; then
    echo "Finalizing ZSH configuration..."
    # Ensure Powerlevel10k theme
    grep -q "powerlevel10k/powerlevel10k" ~/.zshrc || sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    
    # Ensure plugin configuration
    grep -q "zsh-syntax-highlighting" ~/.zshrc || sed -i 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting)/' ~/.zshrc
    
    # Ensure p10k configuration is sourced
    grep -q "p10k.zsh" ~/.zshrc || echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
fi

# Set default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh. Please log out and back in."
fi

echo "Setup complete!"
echo "Vim configuration:"
echo "  - .vimrc symlinked from repository"
echo "Powerlevel10k configuration:"
echo "  - Run 'p10k configure' to customize your prompt"
echo "  - .p10k.zsh symlinked from repository"
