# Neovim Configuration

A minimal, reproducible Neovim setup for Elixir, Gleam, Go, and Zig.

## Neovim Version

- **Installed version**: NVIM v0.12.3
- **Minimum required**: NVIM v0.12.0
- **Build Type**: RelWithDebInfo
- **LuaJIT**: 2.1.1774638290

The config checks the Neovim version on startup and exits early if it is older than v0.12.0.

---

## Prerequisites

Before installing, ensure you have:

- **Neovim v0.12+** (required for `vim.lsp.config` / `vim.lsp.enable` and native snippets)
- **Git** (for cloning plugins and lazy.nvim)
- **ripgrep (rg)** - Required for Telescope live grep (`<leader>fg`)
- **A Nerd Font** (optional) - For file icons in neo-tree

### Install ripgrep

```bash
# Ubuntu/Debian
sudo apt-get install ripgrep

# macOS
brew install ripgrep

# Arch
sudo pacman -S ripgrep
```

---

## Plugins

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. Plugin versions are pinned in `lazy-lock.json`.

### Core plugins

| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration helper |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | Colorscheme (Duskfox) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer tree |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs, blame, and diff |

### Dependencies

| Plugin | Description |
|--------|-------------|
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library |

---

## LSP Servers

Configured using Neovim's built-in `vim.lsp.config()` and `vim.lsp.enable()` APIs.

| Language | Server | Command |
|----------|--------|---------|
| Elixir | elixirls | `$ELIXIR_LS_PATH` or `$HOME/.elixir-ls/release/language_server.sh` or `elixir-ls` |
| Gleam | gleam | `gleam lsp` |
| Go | gopls | `gopls` |
| Zig | zls | `zls` |

### ElixirLS path

The config looks for ElixirLS in this order:

1. `$ELIXIR_LS_PATH` environment variable
2. `$HOME/.elixir-ls/release/language_server.sh`
3. `elixir-ls` on your `$PATH`

If your ElixirLS is installed somewhere else, set the environment variable:

```bash
export ELIXIR_LS_PATH=/path/to/your/language_server.sh
```

---

## Treesitter Parsers

Installed automatically on startup if missing:

- elixir
- eex
- heex
- zig
- markdown
- markdown_inline

---

## Key Bindings

### Leader keys

- **Leader**: `<Space>`
- **Local Leader**: `,`

### Window / tab navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Switch to next window |
| `<C-j>` | Next tab |
| `<leader>tt` | Open terminal in new tab |

### Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fb` | List buffers |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fh` | Help tags |
| `<leader>fd` | Live grep with trimmed yanked text |

Pressing `<CR>` on a Telescope result also reveals the file in Neo-tree when Neo-tree is open.

### File explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree |

Neo-tree automatically opens on startup.

### Git (gitsigns)

| Key | Action |
|-----|--------|
| `<leader>gb` | Blame line and copy commit hash to clipboard |
| `<leader>gd` | Toggle diff of current file in a new tab |
| `q` | Close the diff tab (inside diff view) |

### Google search

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Google search popup |

Type a query and press `<CR>` to open the results in Chrome/Chromium (or Chrome on Windows when running under WSL). Press `<Esc>` or `q` to close the popup without searching.

### Autocompletion

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |

---

## Settings

- Tab stop: 4 spaces
- Shift width: 4 spaces
- Expand tabs to spaces
- Line numbers: enabled
- True color (`termguicolors`): enabled
- Diagnostic virtual text: enabled
- Diagnostic underline: enabled
- Diagnostic signs: disabled
- Colorscheme: Duskfox

---

## Installation

1. Ensure prerequisites are installed (Neovim v0.12+, git, ripgrep).
2. Clone this repository to your Neovim config directory:

   ```bash
   git clone https://github.com/AdwayKasture/neovim_config.git ~/.config/nvim
   ```

3. Start Neovim. lazy.nvim will bootstrap automatically and install all pinned plugins:

   ```bash
   nvim
   ```

4. Install the language servers you need:
   - [ElixirLS](https://github.com/elixir-lsp/elixir-ls) for Elixir
   - [Gleam LSP](https://gleam.run/language-server/) for Gleam
   - [gopls](https://github.com/golang/tools/tree/master/gopls) for Go
   - [zls](https://github.com/zigtools/zls) for Zig

---

## Reproducibility

This repo includes `lazy-lock.json`, which pins every plugin to an exact Git commit. After cloning:

- Run `:Lazy restore` to force the exact commits listed in the lock file.
- Run `:Lazy update` if you want to move to newer plugin versions.

To capture changes from your live setup back into the repo, copy `~/.config/nvim/init.lua` and `~/.config/nvim/lazy-lock.json` into the repo and commit.

---

## Troubleshooting

### "This config requires Neovim >= 0.12.0"

Upgrade Neovim to v0.12.0 or newer. This config uses `vim.lsp.config()` and the new `nvim-treesitter` API.

### Telescope live grep (`<leader>fg`) doesn't work

Make sure ripgrep is installed and on your `$PATH`:

```bash
which rg
```

### Elixir LSP not starting

Check that the ElixirLS path exists:

```bash
ls "$HOME/.elixir-ls/release/language_server.sh"
```

If it is installed elsewhere, set `$ELIXIR_LS_PATH` before launching Neovim.

### Colorscheme not loading

Run `:Lazy sync` in Neovim to reinstall plugins using the pinned versions.

### Plugin lock file issues

If plugins look out of sync with the lock file:

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
