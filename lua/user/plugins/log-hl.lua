local ft = { "log", "txt", "logs" }
return {
  "fei6409/log-highlight.nvim",
  ft = ft,
  config = function()
    require("log-highlight").setup {
      extension = ft,
    }
  end,
}
