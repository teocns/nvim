return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  after = "nvim-treesitter",
  cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
  ft = {
    "python",
    "cpp",
    "c",
    "lua",
    "rust",
    "typescript",
    "javascript",
  },
  lazy = true,
  opts = {
    enable = true,
    max_lines = 3,
    min_window_height = 30,
    mode = "topline",
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    zindex = 20,
  },
  keys = {
    {
      "[C",
      mode = { "n", "v" },
      function() require("treesitter-context").go_to_context(vim.v.count1) end,
      silent = true,
      desc = "Go to context",
    },
  },
}
