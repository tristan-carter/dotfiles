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
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "windwp/nvim-autopairs" },
  { "kyazdani42/nvim-tree.lua" },
  { "tpope/vim-fugitive" },
  { "christoomey/vim-tmux-navigator" },
})

-- ── General settings ────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.cmd[[colorscheme gruvbox]]

-- ── Treesitter ──────────────────────────────────────
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "lua" },
  highlight = { enable = true },
}

-- ── Lualine ─────────────────────────────────────────
require('lualine').setup {
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = ''
  }
}

-- ── Autopairs ───────────────────────────────────────
require('nvim-autopairs').setup{}
