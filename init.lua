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
    { "morhetz/gruvbox" },

    -- Treesitter for syntax highlighting
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

    -- Status line
    { "nvim-lualine/lualine.nvim" },

    -- Autopairs
    { "windwp/nvim-autopairs" },

    -- Git integration
    { "tpope/vim-fugitive" },
})

-- =========================
-- Editor settings
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"  -- system clipboard
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.cmd[[colorscheme gruvbox]]

-- =========================
-- Treesitter configuration
-- =========================
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "lua" },
  highlight = { enable = true },
}

-- =========================
-- Lualine configuration
-- =========================
require('lualine').setup {
    options = {
        theme = 'gruvbox',
        section_separators = '',
        component_separators = '',
        globalstatus = true
    }
}

-- =========================
-- Autopairs setup
-- =========================
require('nvim-autopairs').setup{}

