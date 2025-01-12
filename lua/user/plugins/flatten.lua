return {
  "willothy/flatten.nvim",
  -- config = true,
  opts = {
    -- nest_if_no_args = true,
    one_per = {
      "kitty"
    },
    window = {
      open = "alternate",
    },
  },
  -- or pass configuration with
  -- opts = {  }
  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
}
