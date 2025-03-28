# Ultimate Vim Development Environment

A powerful Vim configuration tailored for modern development workflows, featuring LSP support, fuzzy finding, git integration, and intelligent code completion. Designed for Debian-based systems but adaptable to any Linux distribution.

## Environment targete audience:
Lsp and snippets will be beneficial to:

- C/Cpp coders
- Python coders
- Embedded systems developers (arduino, stm32 and esp32)

## ✨ Key Features
- **Language Server Protocol (LSP)** support for Python, C/C++, Rust
- **Zsh** shell with **Oh My Zsh** and **Powerlevel10k** theme
- **Gruvbox** color scheme with true color support
- **FZF** fuzzy finding integration
- **NERDTree** file explorer
- **Git integration** with Fugitive
- **Undo Tree** visualization
- **Autocomplete** with snippets support(esp32 and stm32 included)
- **Modern editing** with relative numbers and smooth scrolling

## 🛠️ Installation

### Prerequisites
- Vim 8.2+ or Neovim
- Git
- Python 3.8+
- clangd (C/C++ LSP)
- python-lsp-server (Python LSP)

### Installation Steps
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
git clone https://github.com/Madfury0/.dotfiles.git
cd ~/.dotfiles/scripts
chmod +x setup.sh
./setup.sh
```

## ⌨️ Key Bindings

### Leader Key
All key combinations start with **<Space>** (leader key)

### Core Operations
| Key | Action                     |
|-----|----------------------------|
| `w` | Save current file          |
| `q` | Quit Vim                   |
| `r` | Redo changes               |
| `sh`| Open terminal              |
| `e` | File explorer              |
| `u` | Toggle Undo Tree           |

### Navigation
| Key  | Action                      |
|------|-----------------------------|
| `n`  | Toggle NERDTree             |
| `pv` | Previous tab                |
| `pn` | Next tab                    |
| `C-d`| Scroll down (centered)      |
| `C-u`| Scroll up (centered)        |
| `fz` | Fuzzy file search (FZF)     |
| `g`  | Live grep (Ripgrep)         |

### LSP & Code Actions
| Key | Action                      |
|-----|-----------------------------|
| `gd`| Go to definition            |
| `gr`| Find references             |
| `gi`| Go to implementation        |
| `rn`| Rename symbol               |
| `ff`| Format document             |
| `K` | Show hover documentation    |
| `d` | Document diagnostics         |
| `D` | Workspace diagnostics       |
| `qf`| Quickfix actions            |

### Git Integration
| Key | Action                      |
|-----|-----------------------------|
| `gs`| Git status                  |
| `gm`| Git commit                  |
| `gp`| Git push                    |

### Code Editing
| Key Combination       | Action                   |
|-----------------------|--------------------------|
| `jj` (Insert mode)    | Exit insert mode         |
| `<leader>y` (Visual)  | Yank to system clipboard |
| `Tab` (Insert)        | Next completion item    |
| `Shift-Tab` (Insert)  | Previous completion item|

## 🐧 Other Distributions
Replace `apt` commands in setup.sh with your package manager:

**Fedora/RHEL:**
```bash
sudo dnf 
```

**Arch Linux:**
```bash
sudo pacman -S 
```

## 🎨 Theme Customization
To modify the Gruvbox theme:
1. Edit `~/.vimrc`
2. Replace `colorscheme gruvbox` with your preferred theme
3. Ensure terminal supports true colors with:
   ```bash
   echo "set termguicolors" >> ~/.vimrc
   ```

## 🚀 Recommended Workflow
1. Open project with `vim .`
2. `<Space>n` to toggle file tree
3. `<Space>fz` to fuzzy-find files
4. Use `gd` and `K` for code navigation
5. `<Space>ff` to format code
6. `<Space>gs` for git operations

## ⚙️ Plugin Management
- Add plugins in `~/.vimrc` between `plug#begin` and `plug#end`
- Run `:PlugInstall` after making changes
- Update plugins with `:PlugUpdate`