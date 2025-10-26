-- =========================
-- Lazy.nvim plugin manager
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    -- Color scheme
    { "morhetz/gruvbox" },           -- classic dark hacker vibe
    { "catppuccin/nvim", name = "catppuccin" }, -- alternative soft theme

    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

    -- Status line
    { "nvim-lualine/lualine.nvim" },

    -- Autopairs
    { "windwp/nvim-autopairs" },

    -- File explorer (optional)
    { "kyazdani42/nvim-tree.lua" },

    -- Git integration
    { "tpope/vim-fugitive" },
})

-- =========================
-- General settings
-- =========================
vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"  -- system clipboard
vim.cmd[[colorscheme gruvbox]]      -- pick your theme

-- =========================
-- Treesitter setup
-- =========================
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "lua" },
  highlight = { enable = true },
}

-- =========================
-- Lualine setup
-- =========================
require('lualine').setup {
    options = {
        theme = 'gruvbox',
        section_separators = '',
        component_separators = ''
    }
}

-- =========================
-- Autopairs
-- =========================
require('nvim-autopairs').setup{}

