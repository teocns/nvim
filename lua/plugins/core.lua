return {
  { "nvim-lua/plenary.nvim",      lazy = true, commit = "2d9b06177a975543726ce5c73fca176cedbffe9d" },
  { "echasnovski/mini.bufremove", lazy = true },
  {
    "AstroNvim/astrotheme",
    lazy = true,
    opts = {
      plugins = { ["dashboard-nvim"] = false, ["neo-tree"] = false },
      style = { transparent = true, inactive = false, neotree = false, float = false },
    },
  },
  { "max397574/better-escape.nvim", event = "InsertCharPre",  opts = { timeout = 175 } },
  { "NMAC427/guess-indent.nvim",    event = "User AstroFile", config = require "plugins.configs.guess-indent" },
  {
    "stevearc/resession.nvim",
    enabled = vim.g.resession_enabled == true,
    lazy = true,
    opts = {
      buf_filter = function(bufnr) return require("astronvim.utils.buffer").is_restorable(bufnr) end,
      tab_buf_filter = function(tabpage, bufnr) return vim.tbl_contains(vim.t[tabpage].bufs, bufnr) end,
      extensions = { astronvim = {} },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    lazy = true,
    main = "window-picker",
    opts = { picker_config = { statusline_winbar_picker = { use_winbar = "smart" } } },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = true,
    event = "User AstroFile",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt", "TelescopePrompt", "Trouble" },
      ignored_buftypes = { "nofile" },
    },
  },
  {
    "windwp/nvim-autopairs",
    -- event = "User AstroFile",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { java = false },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = require "plugins.configs.nvim-autopairs",
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>" },
    opts = {
      icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
      disable = { filetypes = { "TelescopePrompt" } },
    },
    config = require "plugins.configs.which-key",
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },
}
