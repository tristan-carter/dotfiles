```lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "morhetz/gruvbox" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "windwp/nvim-autopairs" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },
  { "christoomey/vim-tmux-navigator" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
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
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "nvimtools/none-ls.nvim" },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.cmd[[colorscheme gruvbox]]

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "cpp", "lua", "rust", "toml", "python", "bash"
  },
  auto_install = true,
  highlight = { enable = true },
}

require("lualine").setup {
  options = {
    theme = "gruvbox",
    section_separators = "",
    component_separators = "",
  },
}

require("nvim-autopairs").setup {}

require("nvim-tree").setup {}

require("telescope").setup {}

require("gitsigns").setup()

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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { 'pyright', 'clangd', 'lua_ls' }
for _, lsp in ipairs(servers) do
  local opts = {
    capabilities = capabilities,
  }
  if lsp == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      }
    }
  end
  vim.lsp.config(lsp, opts)
  vim.lsp.enable(lsp)
end

local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { '-i', 'dap' }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = "${workspaceFolder}/data_structures",
    cwd = "${workspaceFolder}",
  }
}

local null_ls = require("none-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.diagnostics.cppcheck,
  },
})

-- Keymaps
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', '<leader>m', ':make<CR>', { desc = 'Run Make' })
vim.keymap.set('n', '<leader>mc', ':make clean<CR>', { desc = 'Make Clean' })
vim.keymap.set('n', '<leader>mr', ':make run<CR>', { desc = 'Make Run' })
vim.keymap.set('n', '<leader>d', require'dap'.continue, { desc = 'Debug Continue' })
vim.keymap.set('n', '<leader>du', require'dapui'.toggle, { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<leader>mv', ':!valgrind --leak-check=full ./data_structures<CR>', { desc = 'Valgrind Leak Check' })
vim.keymap.set('n', '<leader>ff', require'telescope.builtin'.find_files, { desc = 'Find Files' })
```
