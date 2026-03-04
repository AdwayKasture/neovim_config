# Neovim Configuration

## Neovim Version

- **Version**: NVIM v0.11.5
- **Build Type**: RelWithDebInfo
- **LuaJIT**: 2.1.1741730670

---

## Prerequisites

Before installing, ensure you have:

- **Neovim v0.10+** (for native snippet support)
- **Git** (for cloning and lazy.nvim)
- **ripgrep (rg)** - Required for Telescope live grep (`<leader>fg`)
- **A Nerd Font** (optional) - For file icons in neo-tree

### Install ripgrep on Ubuntu/Debian:
```bash
sudo apt-get install ripgrep
```

---

## Plugins

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

### Core Plugins

| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration for Elixir, Gleam, and Go |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | Colorscheme (Duskfox) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer tree |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |

### AI/Assist Plugins

| Plugin | Description |
|--------|-------------|
| [avante.nvim](https://github.com/yetone/avante.nvim) | AI-powered code assistance |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot integration |

### Utility Plugins

| Plugin | Description |
|--------|-------------|
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | FZF integration for fuzzy finding |
| [mini.pick](https://github.com/echasnovski/mini.pick) | Minimal picker/fuzzy finder |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Collection of small QoL plugins |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | Improved UI for input/select |
| [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim) | Paste images from clipboard |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown rendering improvements |

### Dependencies

| Plugin | Description |
|--------|-------------|
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library |

---

## LSP Servers Configured

- **Elixir**: elixirls (`/home/archon/.elixir-ls/release/language_server.sh`)
  - ⚠️ **Note**: Hardcoded path - update for your system
- **Gleam**: gleam lsp
- **Go**: gopls

---

## Treesitter Parsers

- elixir
- eex
- heex

---

## Custom Key Bindings

### Leader Keys

- **Leader**: `<Space>`
- **Local Leader**: `,`

### Window Navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Switch to next window |

### Tab Navigation

| Key | Action |
|-----|--------|
| `<C-j>` | Next tab |
| `<leader>tt` | Open terminal in new tab |

### Telescope (File Search)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fb` | List buffers |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fh` | Help tags |
| `<leader>fd` | Live grep with yanked text (NOTE: crashes if empty buffer yanked) |

### File Explorer

- Neo-tree is toggled on startup

### Autocompletion

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |

---

## Settings

- Tab stop: 4 spaces
- Line numbers: enabled
- Diagnostic virtual text: enabled
- Colorscheme: Duskfox

---

## Installation

1. Ensure prerequisites are installed (Neovim v0.10+, git, ripgrep)
2. Clone this repository to your Neovim config directory:
   ```bash
   git clone https://github.com/AdwayKasture/neovim_config.git ~/.config/nvim
   ```
3. Start Neovim - lazy.nvim will bootstrap automatically and install all plugins
   ```bash
   nvim
   ```
4. For LSP support, ensure language servers are installed:
   - ElixirLS for Elixir (update the hardcoded path in `init.lua`)
   - Gleam LSP for Gleam
   - gopls for Go

---

## Troubleshooting

### "attempt to call a nil value" error with Telescope

**Cause**: Telescope keymaps may be triggered before telescope is fully loaded.

**Solution**: 
- Restart Neovim and wait for all plugins to install on first run
- Run `:Lazy sync` to ensure all plugins are up to date
- Check that ripgrep is installed: `which rg`

### Live grep (`<leader>fg`) doesn't work

**Cause**: ripgrep (rg) not installed.

**Solution**: Install ripgrep:
```bash
# Ubuntu/Debian
sudo apt-get install ripgrep

# macOS
brew install ripgrep

# Arch
sudo pacman -S ripgrep
```

### Elixir LSP not working

**Cause**: Hardcoded path doesn't exist on your system.

**Solution**: Update line 33 in `init.lua`:
```lua
cmd = { "/home/archon/.elixir-ls/release/language_server.sh" },
```
Change to your actual ElixirLS installation path.

### Colorscheme not loading

**Cause**: Plugin not installed properly.

**Solution**: Run `:Lazy sync` in Neovim to reinstall plugins.

### Plugin lock file issues

This repo includes `lazy-lock.json` which pins exact plugin versions. If you want to update plugins:
```vim
:Lazy update
```

To use the exact versions from this repo:
```vim
:Lazy restore
```

---

## File Structure

```
~/.config/nvim/
├── init.lua          # Main configuration file
└── lazy-lock.json    # Plugin version lock file
```

---

## Version Control

This configuration uses `lazy-lock.json` to ensure reproducible plugin versions across machines. When cloning to a new machine:

1. The lock file ensures you get the exact same plugin commits
2. Run `:Lazy restore` if you want to force the locked versions
3. Run `:Lazy update` if you want to update to latest versions
