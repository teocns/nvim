return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "FzfLua" },
  keys = {
    { "<F2>", "<cmd>FzfLua<CR>", mode = { "i", "n", "v" }, desc = "FzfLua" },
  },
  opts = {
    "max-perf",
    files = {
      file_icons = false,
      git_icons = false,
    },
  },
}
