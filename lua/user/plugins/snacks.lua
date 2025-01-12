return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- Enable features that don't conflict with current setup
        -- bigfile = { enabled = true },
        quickfile = { enabled = true },
        -- scroll = { enabled = false },
        -- statuscolumn = { enabled = true },
        -- words = { enabled = true },

        -- Disable features that would conflict with existing plugins
        {
          dashboard = { example = "github" }
        },
        indent = { enabled = true }, -- Keep indent-blankline
        input = { enabled = true },  -- Keep dressing.nvim
        notifier = { enabled = true }, -- Keep nvim-notify

        -- Configure enabled features
        bigfile = {
            features = {
                "indent",
                "syntax",
                "treesitter",
                "filetype",
                "lsp",
                "vimopts",
            },
            size = 1024 * 1024, -- 1MB
        },

        scroll = {
            enabled = false,
            -- Smooth scrolling configuration
            keys = {
                ["<C-u>"] = { mode = { "n", "x" }, scroll = -0.5 },
                ["<C-d>"] = { mode = { "n", "x" }, scroll = 0.5 },
                ["<C-b>"] = { mode = { "n", "x" }, scroll = -1.0 },
                ["<C-f>"] = { mode = { "n", "x" }, scroll = 1.0 },
            },
        },

        statuscolumn = {
            -- Enhanced statuscolumn with signs, line numbers, and folds
            scope = {
                enabled = true,
                show_end = false,
                show_start = true,
                injected_languages = false,
                highlight = { "Function", "Label" },
            },
        },

        words = {
            -- Word highlighting and navigation
            hl_group = "IncSearch",
            jump = {
                forward = "<C-n>",
                backward = "<C-p>",
            },
        },
    },
}
