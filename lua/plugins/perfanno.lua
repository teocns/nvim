return {
    "t-troebst/perfanno.nvim",
    lazy = true,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
        "PerfLuaProfileStart",
        "PerfLuaProfileStop",
        "PerfAnnotate",
        "PerfHottestLines",
        "PerfHottestSymbols",
        "PerfToggleAnnotations",
    },
    keys = {
        { "<leader>ps", "<cmd>PerfLuaProfileStart<cr>",   desc = "Start Lua profiling" },
        { "<leader>px", "<cmd>PerfLuaProfileStop<cr>",    desc = "Stop Lua profiling" },
        { "<leader>ph", "<cmd>PerfHottestLines<cr>",      desc = "Show hottest lines" },
        { "<leader>pf", "<cmd>PerfHottestSymbols<cr>",    desc = "Show hottest symbols" },
        { "<leader>pt", "<cmd>PerfToggleAnnotations<cr>", desc = "Toggle performance annotations" },
    },
    opts = {
        -- line_highlights = util.make_bg_highlights("#002200", "#cc3300", 15),
        -- vt_highlight = util.make_fg_highlight "#ff6600",

        analyzer = {
            percentage = false,
            relative = false,
            time_format = "%.3fms",
            calculate_time = true,
            track = {
                calls = true,
                time = true,
            },
            annotate_format = " ⏱️ time: %s | calls: %d",
            profile_type = "cpu",
        },

        -- debug.sethook(nil)
        -- perfanno.stop_profiling()
        -- perfanno.reset()
        -- perfanno.start_profiling()
    },
}
