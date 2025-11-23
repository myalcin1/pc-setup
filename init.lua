-- settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.mouse = ""
vim.opt.guicursor = ""

vim.opt.undofile = true
vim.opt.undolevels = 0xffff

vim.opt.smartindent = true
vim.opt.wrap = false

-- vim.opt.hlsearch = false
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'typescript', 'html', 'css', 'scss', 'json', 'yaml', 'markdown'},
    command = 'setlocal tabstop=2 shiftwidth=2'
})

-- remaps
vim.g.mapleader = " "

vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("i", "\"\"\"", "\"\"\"\"\"\"<left><left><left>")
vim.keymap.set("i", "\"\"", "\"\"")
vim.keymap.set("i", "\"", "\"\"<left>")
vim.keymap.set("i", "''", "''")
vim.keymap.set("i", "'", "''<left>")
vim.keymap.set("i", "()", "()")
vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "{}", "{}")
vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")
vim.keymap.set("i", "{;<CR>", "{<CR>};<ESC>O")

vim.keymap.set("v", "J", ":m '>+1<CR>gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<A-r>", ":cnext<CR>")
vim.keymap.set("n", "<A-e>", ":cprev<CR>")

vim.keymap.set("n", "<A-y>", "<C-w><")
vim.keymap.set("n", "<A-u>", "<C-w>+")
vim.keymap.set("n", "<A-i>", "<C-w>-")
vim.keymap.set("n", "<A-o>", "<C-w>>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<A-d>", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>") -- learn
vim.keymap.set("v", "<A-d>", "\"dy:%sno/<C-r>d//gI<Left><Left><Left>")     -- learn
vim.keymap.set("v", "/", "\"dy/\\V<C-r>d<CR>")                             -- learn
vim.keymap.set("v", "?", "\"dy/\\V<C-r>d\\c<CR>")                          -- learn

vim.keymap.set("v", "<A-p>", "\"_dP")
vim.keymap.set("v", "<A-d>", "\"_d")
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y")
vim.keymap.set({"n", "v"}, "<leader>p", "\"+p")

vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "jj", "<C-\\><C-N>")
vim.keymap.set("t", "<C-d>", "<C-\\><C-d>")

-- terminal previous line
_G.jump_to_prompt = function(forward)
    local user = vim.fn.expand("$USER")
    local host = vim.fn.hostname()
    local pattern = string.format([[%s@%s]], vim.pesc(user), vim.pesc(host))
    local found
    if forward == true then
        found = vim.fn.search(pattern, 'w')
    else
        found = vim.fn.search(pattern, 'bw')
    end

    if found ~= 0 then
        print("Jumped to prompt at line " .. found)
    else
        print("No prompt in this buffer.")
    end
end

vim.keymap.set('n', '<C-u>', [[<Cmd>lua jump_to_prompt(true)<CR>]], {noremap = true, silent = true})
vim.keymap.set('n', '<C-i>', [[<Cmd>lua jump_to_prompt(false)<CR>]], {noremap = true, silent = true})

-- plugins
local plugins = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    -- {
    --    "navarasu/onedark.nvim",
    --    opts = { style = "darker" },
    --    priority = 1000,
    --    config = function ()
    --        vim.cmd.colorscheme("onedark")
    --    end
    -- },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "c", "cpp", "python", "markdown", "javascript"},
                highlight = { enable = true }
            })
        end
    },
    { "nvim-treesitter/nvim-treesitter-context" },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end
    },
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            local api = require("nvim-tree.api")
            vim.keymap.set("n", "<A-b>", "<cmd> NvimTreeToggle <CR>")
            vim.keymap.set("n", "<A-I>", api.tree.toggle_gitignore_filter)
        end
    },
    { "lewis6991/gitsigns.nvim", config = true },
    {
        "nvim-lualine/lualine.nvim",
        config = true,
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    {
        "sindrets/diffview.nvim",
        config = function ()
            vim.keymap.set("n", "<A-g>", "<cmd> DiffviewOpen <CR>")
            vim.keymap.set("n", "<A-G>", "<cmd> DiffviewClose <CR>")
        end
    },
    { "mg979/vim-visual-multi" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    {
        "numToStr/Comment.nvim",
        opts = { mappings = false },
        config = function ()
            vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)")
            vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)")
        end
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function ()
            vim.keymap.set({"n", "t"}, "<A-m>", function () require("toggleterm").toggle(vim.v.count) end)
        end
    },
    {
        "romgrk/barbar.nvim",
        opts = { mappings = false },
        config = function ()
            vim.keymap.set("n", "<A-j>", "<cmd> BufferPrevious <CR>")
            vim.keymap.set("n", "<A-k>", "<cmd> BufferNext <CR>")
            vim.keymap.set("n", "<A-J>", "<cmd> BufferMovePrevious <CR>")
            vim.keymap.set("n", "<A-K>", "<cmd> BufferMoveNext <CR>")
            vim.keymap.set("n", "<A-w>", "<cmd> BufferClose <CR>")
            -- vim.keymap.set("n", "<A-1>", "<cmd> BufferGoto 1 <CR>")
            -- vim.keymap.set("n", "<A-2>", "<cmd> BufferGoto 2 <CR>")
            -- vim.keymap.set("n", "<A-3>", "<cmd> BufferGoto 3 <CR>")
            -- vim.keymap.set("n", "<A-4>", "<cmd> BufferGoto 4 <CR>")
            -- vim.keymap.set("n", "<A-5>", "<cmd> BufferGoto 5 <CR>")
            -- vim.keymap.set("n", "<A-6>", "<cmd> BufferGoto 6 <CR>")
            -- vim.keymap.set("n", "<A-7>", "<cmd> BufferGoto 7 <CR>")
            -- vim.keymap.set("n", "<A-8>", "<cmd> BufferGoto 8 <CR>")
            -- vim.keymap.set("n", "<A-9>", "<cmd> BufferGoto 9 <CR>")
            -- vim.keymap.set("n", "<A-0>", "<cmd> BufferLast <CR>")
        end
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function ()
            local persist = require("persistence")
            vim.keymap.set("n", "<leader>ql", function () persist.load({ last = true }) end)  -- learn
            vim.keymap.set("n", "<leader>qs", function () persist.load() end)                 -- learn
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local cmp = require("cmp")
            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                },
                mapping = {
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                }
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "cmake",
                    "jsonls",
                    "pylsp",
                    "lua_ls",
                    "ts_ls",
                    "eslint",
                    "html",
                }
            })
            lspconfig["clangd"].setup({})
            lspconfig["cmake"].setup({})
            lspconfig["jsonls"].setup({})
            lspconfig["pylsp"].setup({
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                maxLineLength = 120,
                            }
                        }
                    }
                }
            })
            lspconfig["lua_ls"].setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            lspconfig["ts_ls"].setup({})
            lspconfig["eslint"].setup({})
            lspconfig["eslint"].setup({})
            vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)
            vim.keymap.set("n", "ge", vim.lsp.buf.rename)
            vim.keymap.set("n", "gf", vim.lsp.buf.code_action)
            vim.keymap.set("n", "K", vim.lsp.buf.hover)
        end,
    },
--        "j-hui/fidget.nvim",
}

-- lazypath
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup(plugins, {})
