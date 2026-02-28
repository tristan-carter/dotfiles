-- ── Bootstrap Lazy.nvim ──────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── General Configuration ────────────────────────────────
vim.g.mapleader = " "

-- UI & Layout
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- ── Remote Clipboard (OSC 52) ────────────────────────────
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}
vim.opt.clipboard = "unnamedplus"

-- ── Plugin Specification ─────────────────────────────────
require("lazy").setup({
    -- UI & Theme
    { "folke/tokyonight.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "lewis6991/gitsigns.nvim" },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- Navigation
    { "christoomey/vim-tmux-navigator" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "tpope/vim-fugitive" },

    -- Syntax & Parsing
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "windwp/nvim-autopairs" },

    -- LSP & Auto-Completion (Mason Stack)
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        }
    },

    -- Debugging & Linting
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    { "nvimtools/none-ls.nvim" },
})

-- ── Theme Setup ──────────────────────────────────────────
require("tokyonight").setup({
    style = "night",
    transparent = true,
    terminal_colors = false,
    styles = {
        comments = { italic = true, bold = false },
        keywords = { italic = false, bold = false },
        functions = { bold = false },
        variables = { bold = false },
        sidebars = "dark",
        floats = "dark",
    },
    on_highlights = function(hl, c)
        hl.Normal = { fg = c.fg_dark, bg = c.bg_dark }
        hl.Comment = { fg = c.dark3 }
        hl.String = { fg = c.green1 }
    end,
})
vim.cmd[[colorscheme tokyonight]]

-- ── Mason & LSP Configuration ────────────────────────────
require("mason").setup()

local servers = { "clangd", "pyright", "lua_ls" }

require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = false,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local server_settings = {
    ["lua_ls"] = {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
    }
}

require("mason-lspconfig").setup_handlers({
    function(server_name)
        local config = { capabilities = capabilities }
        
        if server_name == "lua_ls" then
            config.settings = server_settings["lua_ls"].settings
        end

        if vim.fn.has("nvim-0.11") == 1 then
            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        else
            require("lspconfig")[server_name].setup(config)
        end
    end,
})

-- ── Treesitter Configuration ─────────────────────────────
require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "lua", "rust", "python", "bash" },
    auto_install = true,
    highlight = { enable = true },
}

-- ── Autocompletion (CMP) ─────────────────────────────────
local cmp = require("cmp")
cmp.setup({
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- ── Debugging (DAP) ──────────────────────────────────────
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
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
    }
}
dap.configurations.cpp = dap.configurations.c

-- ── Formatting & Linting ─────────────────────────────────
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.diagnostics.cppcheck,
    },
})

-- ── Setup Lualine, Autopairs, etc. ───────────────────────
-- Updated to Tokyonight theme!
require("lualine").setup { options = { theme = "tokyonight", section_separators = "", component_separators = "" } }
require("nvim-autopairs").setup {}
require("nvim-tree").setup {}
require("telescope").setup {}
require("gitsigns").setup()

-- ── Keymaps ──────────────────────────────────────────────
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })

vim.keymap.set('n', '<leader>m', ':make<CR>', { desc = 'Run Make' })
vim.keymap.set('n', '<leader>mr', ':make run<CR>', { desc = 'Make Run' })
vim.keymap.set('n', '<leader>mc', ':make clean<CR>', { desc = 'Make Clean' })

vim.keymap.set('n', '<leader>d', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })

vim.keymap.set('n', '<leader>ff', require'telescope.builtin'.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', require'telescope.builtin'.live_grep, { desc = 'Grep Files' })
vim.keymap.set('n', '<leader>fb', require'telescope.builtin'.buffers, { desc = 'Find Buffers' })

vim.keymap.set('n', '<leader>v', ':!valgrind --leak-check=full ./main<CR>', { desc = 'Run Valgrind' })
