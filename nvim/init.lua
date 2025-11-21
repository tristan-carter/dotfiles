-- ── Lazy.nvim plugin manager ────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ─────────────────────────────────────────
require("lazy").setup({
  -- Themes
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },

  -- Treesitter (Syntax Highlighting)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Autopairs (Automatic closing brackets)
  { "windwp/nvim-autopairs" },

  -- File tree
  { "kyazdani42/nvim-tree.lua" },

  -- Git Integration
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },

  -- Tmux navigation
  { "christoomey/vim-tmux-navigator" },

  -- Fuzzy finder
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5" },

  -- LSP (Language Server Protocol)
  { "neovim/nvim-lspconfig" },
  
  -- Autocompletion Engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Connects LSP to CMP
      "hrsh7th/cmp-buffer",   -- Suggest words from current buffer
      "hrsh7th/cmp-path",     -- Suggest file paths
      "L3MON4D3/LuaSnip",     -- Snippets engine
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Rust Specialized Plugin
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },
})

-- ── General settings ────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.cmd[[colorscheme gruvbox]]

-- ── Treesitter ──────────────────────────────────────
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "cpp", "lua", "rust", "toml", "python", "bash"
  },
  highlight = { enable = true },
}

-- ── Lualine ─────────────────────────────────────────
require("lualine").setup {
  options = {
    theme = "gruvbox",
    section_separators = "",
    component_separators = "",
  },
}

-- ── Autopairs ───────────────────────────────────────
require("nvim-autopairs").setup {}

-- ── nvim-cmp setup (Autocompletion) ─────────────────
-- We setup CMP *before* LSP to ensure capabilities are ready
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" }, -- Must be first to prioritize code intelligence
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  },
})

-- ── LSP (Language Server Protocol) ──────────────────
local lspconfig = require("lspconfig")

-- Get the capabilities from cmp-nvim-lsp
-- This tells the servers "Hey, I can support autocompletion!"
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- List of servers to setup (excluding Rust, which is handled by rustaceanvim)
local servers = { 'pyright', 'clangd', 'lua_ls' }

for _, lsp in ipairs(servers) do
  local opts = {
    capabilities = capabilities, -- Pass completion capabilities
  }

  -- Special config for Lua to recognize the 'vim' global variable
  if lsp == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
             library = vim.api.nvim_get_runtime_file("", true),
        },
      }
    }
  end

  -- Initialize the server
  lspconfig[lsp].setup(opts)
end

-- ── Telescope ───────────────────────────────────────
require("telescope").setup {}

-- ── Gitsigns ────────────────────────────────────────
require("gitsigns").setup()

-- ── Terminal window navigation ──────────────────────
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])
