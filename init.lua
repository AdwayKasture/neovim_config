-- Stabilized Neovim config for Neovim 0.12.3
-- Plugin manager: lazy.nvim

-- 1. Version guard -----------------------------------------------------------
local min_nvim_version = "0.12.0"
if vim.fn.has("nvim-" .. min_nvim_version) == 0 then
  vim.notify(
    "This config requires Neovim >= " .. min_nvim_version .. ". Please upgrade.",
    vim.log.levels.ERROR
  )
  return
end

-- 2. Basic options and keymaps -----------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.termguicolors = true

vim.keymap.set("n", "<C-h>", "<C-w>w", { silent = true })
vim.keymap.set("n", "<C-j>", ":tabn<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tt", ":tab term<CR>", { silent = true, noremap = true })

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = false,
  update_in_insert = false,
  severity_sort = true,
})

-- 3. Bootstrap lazy.nvim -----------------------------------------------------
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

-- 4. Plugin definitions ------------------------------------------------------
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Elixir LS path: override with $ELIXIR_LS_PATH, otherwise use the
      -- locally installed release path under $HOME, otherwise fall back to PATH.
      local elixir_ls = vim.env.ELIXIR_LS_PATH
        or (vim.env.HOME and vim.env.HOME .. "/.elixir-ls/release/language_server.sh")
        or "elixir-ls"

      vim.lsp.config("elixirls", {
        cmd = { elixir_ls },
        capabilities = capabilities,
      })
      vim.lsp.enable("elixirls")

      vim.lsp.config("gleam", {
        cmd = { "gleam", "lsp" },
        capabilities = capabilities,
      })
      vim.lsp.enable("gleam")

      vim.lsp.config("gopls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("gopls")

      vim.lsp.config("zls", {
        capabilities = capabilities,
        settings = {
          zls = {
            semantic_tokens = "partial",
          },
        },
      })
      vim.lsp.enable("zls")
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme duskfox")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function neo_tree_is_open()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            return true
          end
        end
        return false
      end

      local function open_and_reveal_in_neo_tree(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.select_default(prompt_bufnr)

        if selection and neo_tree_is_open() then
          local filepath = selection.path or selection.filename or selection.value
          if filepath then
            filepath = vim.fn.fnamemodify(filepath, ":p")
            vim.schedule(function()
              require("neo-tree.command").execute({
                action = "show",
                reveal_file = filepath,
              })
            end)
          end
        end
      end

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<CR>"] = open_and_reveal_in_neo_tree,
            },
            n = {
              ["<CR>"] = open_and_reveal_in_neo_tree,
            },
          },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({})
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install parsers asynchronously on startup (no-op if already installed).
      treesitter.install({ "elixir", "eex", "heex", "zig", "markdown", "markdown_inline" })

      -- Enable treesitter highlighting for supported filetypes.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "elixir", "eelixir", "heex", "zig", "markdown" },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Enable treesitter indentation for supported filetypes.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "elixir", "eelixir", "heex", "zig", "markdown" },
        callback = function()
          pcall(function()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end,
  },
})

-- 5. Google search popup -----------------------------------------------------
local function google_search_popup()
  local Input = require("nui.input")

  local input = Input({
    relative = "editor",
    position = "50%",
    size = { width = 60, height = 10 },
    border = {
      style = "rounded",
      text = {
        top = " Google Search ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    prompt = "> ",
    default_value = "",
    on_submit = function(query)
      local trimmed = vim.trim(query)
      if trimmed == "" then
        return
      end

      -- URL-encode the query (spaces become '+').
      local encoded = trimmed:gsub(" ", "+")
      encoded = encoded:gsub("([^A-Za-z0-9%-_.~+])", function(c)
        return string.format("%%%02X", string.byte(c))
      end)

      local url = "https://www.google.com/search?q=" .. encoded

      local function is_wsl()
        local f = io.open("/proc/version", "r")
        if f then
          local content = (f:read("*a") or ""):lower()
          f:close()
          return content:find("microsoft") or content:find("wsl")
        end
        return false
      end

      local function notify_opened()
        vim.notify("Opened Google search: " .. trimmed, vim.log.levels.INFO)
      end

      if is_wsl() then
        -- Open Chrome on the Windows side via cmd.exe.
        vim.fn.jobstart({ "cmd.exe", "/c", "start", "chrome", url }, { detach = true })
        notify_opened()
        return
      end

      -- Prefer Google Chrome, fall back to Chromium variants.
      local browsers = { "google-chrome", "google-chrome-stable", "chromium", "chromium-browser" }
      local browser = nil
      for _, b in ipairs(browsers) do
        if vim.fn.executable(b) == 1 then
          browser = b
          break
        end
      end

      if not browser then
        vim.notify("No Chrome/Chromium browser found in PATH", vim.log.levels.ERROR)
        return
      end

      vim.fn.jobstart({ browser, url }, { detach = true })
      notify_opened()
    end,
  })

  input:mount()

  -- Close the popup with Esc or q.
  input:map("n", "<Esc>", function()
    input:unmount()
  end, { noremap = true })
  input:map("n", "q", function()
    input:unmount()
  end, { noremap = true })
end

vim.keymap.set("n", "<leader>gg", google_search_popup, { desc = "Google search in Chrome" })

-- 6. Telescope keymaps -------------------------------------------------------
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fd", function()
  local yanked_text = vim.fn.getreg('"')
  local trimmed_text = yanked_text:match("^%s*(.*%S)%s*$") or ""

  if #trimmed_text > 0 then
    builtin.live_grep({ default_text = trimmed_text })
  else
    vim.notify("No meaningful text yanked. Opening live_grep normally.", vim.log.levels.WARN)
    builtin.live_grep()
  end
end, { desc = "Telescope live_grep with trimmed yanked text" })

-- 7. Neo-tree (auto-open on startup + toggle keymap) -------------------------
local function toggle_neo_tree()
  require("neo-tree.command").execute({ toggle = true })
end

vim.keymap.set("n", "<leader>e", toggle_neo_tree, { desc = "Toggle Neo-tree" })

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Neo-tree on startup",
  once = true,
  callback = function()
    toggle_neo_tree()
  end,
})
