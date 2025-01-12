return {
  -- customize alpha options
  {
    "goolord/alpha-nvim",
    enabled = false,
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = "h4xx0r"
      return opts
    end,
  },
  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },
  {
    "rcarriga/nvim-notify",
    enabled = false,
    opts = {
      render = "minimal",
      stages = "static",
      timeout = 1500,
      max_width = 60,
      max_height = 20,
    },
  },
}
