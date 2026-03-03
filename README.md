# Neovim Configuration

## Neovim Version

- **Version**: NVIM v0.11.5
- **Build Type**: RelWithDebInfo
- **LuaJIT**: 2.1.1741730670

---

## Plugins

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

### Installed Plugins

| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration for Elixir, Gleam, and Go |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | Colorscheme (Nightfox) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer tree |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library (dependency) |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons (dependency) |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library (dependency) |

### LSP Servers Configured

- **Elixir**: elixirls (`/home/archon/.elixir-ls/release/language_server.sh`)
- **Gleam**: gleam lsp
- **Go**: gopls

### Treesitter Parsers

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
| `<leader>fd` | Live grep with yanked text (NOTE crashes if empty buffer yanked) |

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

---

## Installation

1. Ensure Neovim v0.11.5+ is installed
2. Clone this repository to your Neovim config directory:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
3. Start Neovim - lazy.nvim will bootstrap automatically and install all plugins
4. For LSP support, ensure language servers are installed:
   - ElixirLS for Elixir
   - Gleam LSP for Gleam
   - gopls for Go

---

## File Structure

```
~/.config/nvim/
└── init.lua          # Main configuration file
```
