return {
  'norcalli/nvim-colorizer.lua',
  -- TODO: only enable for file
  -- FIXME: But which?
  lazy = true,

  cmd = "ColorizerToggle",
  
  config = function()
    require('colorizer').setup()
  end,
}
