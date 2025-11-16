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

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Autopairs
  { "windwp/nvim-autopairs" },

  -- File tree
  { "kyazdani42/nvim-tree.lua" },

  -- Git
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },

  -- Tmux navigation
  { "christoomey/vim-tmux-navigator" },

  -- Fuzzy finder
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5" },

  -- LSP + Completion
  { "neovim/nvim-lspconfig" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },
})

-- ── General settings ────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
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

-- ── LSP (Rust + General) ────────────────────────────
local lspconfig = require("lspconfig")

-- For non-Rust languages
lspconfig.pyright.setup({})
lspconfig.clangd.setup({})
lspconfig.lua_ls.setup({
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } }
  }
})

-- rust-analyzer is auto-managed by rustaceanvim

-- ── nvim-cmp setup (Autocompletion) ─────────────────
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
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  },
})

-- ── Telescope ───────────────────────────────────────
require("telescope").setup {}

-- ── Gitsigns ────────────────────────────────────────
require("gitsigns").setup()
