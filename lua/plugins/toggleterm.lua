-- local terminals = {}
--
-- -- Function to toggle terminal
-- local function toggle_term(direction)
--   local t = require "toggleterm.terminal"
--   local Terminal = t.Terminal
--
--   local term_id = t.get_focused_id()
--   local term = t.get(term_id, true)
--
--   if not term then
--     -- Does it still exist?
--     term = Terminal:new { direction = direction }
--   end
--   -- or not term:is_valid()
--   term:toggle()
-- end
--
return {
  "akinsho/toggleterm.nvim",
  keys = {
    {
      "<A-i>",
      function() require("astronvim.utils").toggle_term_cmd { cmd = "zsh", direction = "float" } end,
      desc = "Toggle terminal (tab)",
      mode = { "n", "v", "i", "c", "t" },
    },
    {
      "<A-I>",
      function() require("astronvim.utils").toggle_term_cmd { cmd = "zsh", direction = "horizontal" } end,
      desc = "Toggle terminal (horizontal)",
      mode = { "n", "v", "i", "c", "t" },
    },
    { "<leader>t<leader>", "<cmd>TermSelect<CR>", desc = "Select terminal" },
  },
  config = function(_, opts) require("toggleterm").setup(opts) end,
  opts = {
    hide_numbers = true,
    autochdir = true,
    shade_filetypes = { "none" },
    -- shell = vim.o.shell,
    shell = "/opt/homebrew/bin/zsh",
    open_mapping = [[<F7>]],
    shade_terminals = false,
    start_in_insert = true,
    direction = "float",
    float_opts = { border = "single" },
    on_open = function() vim.cmd "startinsert!" end,
    persist_size = true,
    persist_mode = false, -- if set to true (default) the previous terminal mode will be remembered

  -- highlights = {
  --   -- highlights which map to a highlight group name and a table of it's values
  --   -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
  --   -- Normal = {
  --   --   guibg = "<VALUE-HERE>",
  --   -- },
  --   -- NormalFloat = {
  --   --   link = 'NONE'
  --   -- },
  --   FloatBorder = {
  --     link = "NONE",
  --     guifg = "NONE",
  --     guibg = "NONE",
  --   },
  -- },

    float_opts = {
      border = 'none',
      width = function() return math.floor(vim.o.columns * 0.99) end,

      height = function() return math.floor((vim.o.lines - vim.o.cmdheight) * 0.99) end,
    },
  },

}
