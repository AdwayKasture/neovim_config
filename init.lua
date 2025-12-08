-- set your leader and local leader key
-- make sure to set `mapleader` and `maplocalleader` before lazy so your mappings are correct
vim.g.mapleader = " " -- using space as leader key
vim.g.maplocalleader = "," -- using comma as local leader
vim.opt.tabstop = 4
vim.opt.number = true
vim.keymap.set("n","<C-h>","<C-w>w", { silent = true })
vim.keymap.set("n","<C-j>",":tabn<CR>", {silent = true, noremap = true})
vim.keymap.set("n","<leader>tt",":tab term<CR>", {silent = true, noremap = true})
vim.diagnostic.config({ virtual_text = true })
-- bootstrap lazy.nvim plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.elixirls.setup({
        cmd = { "/home/archon/.elixir-ls/release/language_server.sh" },
        capabilities = capabilities,
        diagnostic_config = {
          virtual_text = {
            spacing = 4,
            severity = nil, -- Show all severities
          },
          underline = true,
          signs = false,
          update_in_insert = false,
          severity_sort = true,
        },
      }) 
      lspconfig.gleam.setup({
        cmd = { "gleam", "lsp" }, 
        capabilities = capabilities,
      })
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd([[colorscheme nightfox]]) end,
  },
  {
     "nvim-telescope/telescope.nvim",tag = "0.1.8",
     dependencies = {"nvim-lua/plenary.nvim"}
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  {
   "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "elixir", "eex", "heex" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- install different completion source
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        -- add different completion source
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        -- using default mapping preset
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          -- you must specify a snippet engine
          expand = function(args)
            -- using neovim v0.10 native snippet feature
            -- you can also use other snippet engines
            vim.snippet.expand(args.body)
          end,
        },
      })
    end,
  },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n","<leader>ff",builtin.find_files,{desc = "Telescope find files"})
vim.keymap.set("n","<leader>fb",builtin.buffers,{desc = "Telescope buffers"})
vim.keymap.set("n","<leader>fg",builtin.live_grep,{desc = "Telescope live grep"})
vim.keymap.set("n","<leader>fh",builtin.help_tags,{desc = "Telescope help tags"})
vim.keymap.set("n", "<leader>fd", function()
  local yanked_text = vim.fn.getreg('"')
  
  -- Trim whitespace (including newlines) from the yanked text
  local trimmed_text = yanked_text:match("^%s*(.*%S)%s*$") or ""

  if #trimmed_text > 0 then
    -- If, after trimming, there's valid text, use it as default_text
    require('telescope.builtin').live_grep({ default_text = trimmed_text })
  else
    -- If no valid text was yanked (e.g., empty line, only whitespace),
    vim.notify("No meaningful text yanked. Opening live_grep normally.", vim.log.levels.WARN)
    require('telescope.builtin').live_grep()
  end
end, { desc = "Telescope live_grep with trimmed yanked text" })
require("neo-tree.command").execute({ toggle = true, visible = true })
