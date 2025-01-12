-- local harpoon = require "harpoon"
-- harpoon:setup {}
-- -- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers")
--     .new({}, {
--       prompt_title = "Harpoon",
--       finder = require("telescope.finders").new_table {
--         results = file_paths,
--       },
--       previewer = conf.file_previewer {},
--       sorter = conf.generic_sorter {},
--     })
--     :find()
-- end
--
-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
--
return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>fu",
        "<cmd>Telescope undo<cr>",
        desc = "Undo history",
      },
      {
        "<leader>fU",
        "<cmd>Telescope undo_line<cr>",
        desc = "Undo history (line)",
      },
    },
    -- config = function(_, opts)
    --   -- calling telescope's setup from multiple specs does not hurt, it will happily merge the
    --   -- configs for us. we won't use data, as everything is in it's own namespace (telescope
    --   -- defaults, as well as each extension).
    --   require("telescope").setup(opts)
    --   require("telescope").load_extension "undo"
    -- end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>f",
      },
    },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-telescope/telescope-file-browser.nvim" },
    -- opts = {
    --
    --   sync_with_nvim_tree = true,
    -- },
    keys = {
      {
        "<leader>fp",
        function() require("telescope").extensions.project.project { display_type = "full", initial_mode = "insert" } end,
        desc = "Projects",
      },
    },
  },
  {
    "teocns/telescope-frecency.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    dev = true,
    opts = {
      show_unindexed = true,
      db_safe_mode = false,
      matcher = "fuzzy",
      preceding = "same_repo",

      debug_timer = false,

      ---@field recency_values { age: integer, value: integer }[] default: see lua/frecency/config.lua
      ---@field auto_validate boolean default: true
      ---@field bootstrap boolean default: true
      ---@field db_root string default: vim.fn.stdpath "state"
      ---@field db_safe_mode boolean default: true
      ---@field db_validate_threshold integer default: 10
      ---@field debug boolean default: false
      ---@field debug_timer boolean default: false
      ---@field default_workspace? string default: nil
      ---@field disable_devicons boolean default: false
      ---@field enable_prompt_mappings boolean default: false
      ---@field filter_delimiter string default: ":"
      ---@field hide_current_buffer boolean default: false
      ---@field ignore_patterns string[] default: { "*.git/*", "*/tmp/*", "term://*" }
      ---@field ignore_register? fun(bufnr: integer): boolean default: nil
      ---@field matcher "default"|"fuzzy" default: "default"
      ---@field scoring_function fun(recency: integer, fzy_score: number): number default: see lua/frecency/config.lua
      ---@field max_timestamps integer default: 10
      ---@field path_display? table default: nil
      ---@field preceding? "opened"|"same_repo" default: nil
      ---@field show_filter_column boolean|string[] default: true
      ---@field show_scores boolean default: false
      ---@field show_unindexed boolean default: true
      ---@field workspace_scan_cmd? "LUA"|string[] default: nil
      ---@field workspaces table<string, string|string[]> default: {}
    },
    keys = {
      {
        "<leader><leader>",
        function() require("user.util.telescope.actions").frecency() end,
        desc = "Frecency",
      },
    },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
              width = 0.8,
              previewer = false,
              prompt_title = "Code Actions",
              results_title = false,
              layout_config = {
                width = 0.5,
                height = 0.4,
              },
            })
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end,
  }
}
