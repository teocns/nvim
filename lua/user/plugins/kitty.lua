return {
  "mikesmithgh/kitty-scrollback.nvim",
  dir = "~/.config/kitty/kitty-scrollback.nvim",
  -- enabled = true, -- forcees to be enabled in vanilla
  enabled = false,
  setup = function()
    require('kitty-scrollback').setup({
      myconfig = {
        kitty_get_text = {
          ansi = false,
        },
      }
    })
  end
}
