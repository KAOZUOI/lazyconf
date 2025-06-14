-- local format = function() require("lazyvim.plugins.lsp.format").format({ force = true }) end
return {
    { "smjonas/inc-rename.nvim", opts = {} },
    {
        "stevearc/conform.nvim",
        keys = {
            { "<leader>cF", false },
            {
                "<leader>fm",
                -- function() require("conform").format({ formatters = { "injected" } }) end,
                "<cmd>LazyFormat<CR>",
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
            {
                "<leader>cf",
                function()
                    require("conform").format({ formatters = { "gofumpt", "goimports" }, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format Go Code",
            },
            {
                "<leader>ci",
                function()
                    require("conform").format({ formatters = { "goimports" }, lsp_fallback = false })
                end,
                mode = { "n", "v" },
                desc = "Run goimports (Organize Imports)",
            },
        },
        opts = {
            formatters_by_ft = {
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                go = { "gofumpt", "goimports" },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        init = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            -- for index, keymap in pairs(keys) do
            --     if vim.tbl_contains({ "gd", "gr", "K", "<leader>cf" }, keymap[1]) then
            --         keys[index] = false
            --     end
            -- end
            keys[#keys + 1] = { "gd", false }
            keys[#keys + 1] = { "gr", false }
            keys[#keys + 1] = { "K", false }
            keys[#keys + 1] = { "<leader>cf", false }
            keys[#keys + 1] = { "D", vim.lsp.buf.hover, desc = "Hover" }
            -- print(vim.inspect(keys))
        end,

        opts = {
            diagnostics = {
                update_in_insert = true,
                virtual_text = {
                    severity = {
                        vim.diagnostic.severity.INFO,
                        vim.diagnostic.severity.WARN,
                        vim.diagnostic.severity.ERROR,
                        vim.diagnostic.severity.HINT,
                    },
                    prefix = "icons",
                },
                signs = {
                    severity = {
                        vim.diagnostic.severity.HINT,
                    },
                    text = {
                        HINT = "💡",
                    },
                },
            },
            inlay_hints = {
                enabled = false,
            },
            -- autoformat = false,
            format_notify = true,
            servers = {
                -- gopls = require("plugins.lsp.servers.gopls"),
                -- pylance = require("plugins.lsp.servers.pylance"),
                -- ruff = require("plugins.lsp.servers.ruff"),
                clangd = require("plugins.lsp.servers.clangd"),
                lua_ls = require("plugins.lsp.servers.lua_ls"),
            },
            setup = {
            },
        },
    },
    {
        "nvimdev/lspsaga.nvim",
        -- enabled = false,
        event = "LspAttach",
        keys = {
            { "K", false },
            -- {
            --     "D",
            --     "<cmd>Lspsaga hover_doc<cr>",
            --     desc = "Hover",
            -- },
            {
                "gd",
                "<cmd>Lspsaga peek_definition<cr>",
                -- "<C-w>}",
                -- "<cmd>Lspsaga finder def ++inexist<cr>",
                desc = "go to definition",
            },
            {
                "gt",
                "<C-w>}",
                desc = "reference definition",
            },
            {
                "gr",
                "<cmd>Lspsaga finder ++inexist<cr>",
                -- "<cmd>Lspsaga finder<cr>",
                desc = "go to reference",
            },
            {
                "ga",
                "<cmd>Lspsaga code_action<cr>",
                desc = "Code Action (preview)",
                mode = { "n", "v" },
            },
            {
                "<leader>rn",
                "<cmd>Lspsaga rename ++project<cr>",
                desc = "lsp: Rename in project range",
                mode = { "n", "v" },
            },
        },
        config = function()
            local Util = require("lazyvim.util")
            require("lspsaga").setup({
                request_timeout = 3000,
                symbol_in_winbar = {
                    enable = not Util.has("dropbar.nvim"),
                },
                code_action = {
                    num_shortcut = true,
                    show_server_name = true,
                    extend_gitsigns = false,
                    keys = {
                        quit = "q",
                        exec = "<CR>",
                    },
                },
                definition = {
                    width = 0.6,
                    height = 0.5,
                    keys = {
                        edit = "<CR>",
                        vsplit = "v",
                        split = "s",
                        tabe = "t",
                    },
                },
                lightbulb = { enable = false },
                finder = {
                    keys = {
                        toggle_or_open = "<CR>",
                        vsplit = "v",
                        split = "s",
                        tabe = "t",
                    },
                },
                rename = {
                    in_select = false,
                    auto_save = false,
                    project_max_width = 0.5,
                    project_max_height = 0.5,
                    keys = {
                        quit = "<C-q>",
                        exec = "<CR>",
                        select = "x",
                    },
                },
                scroll_preview = {
                    scroll_down = "<C-d>",
                    scroll_up = "<C-u>",
                },
            })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter", -- optional
            "nvim-tree/nvim-web-devicons", -- optional
        },
    },
}
