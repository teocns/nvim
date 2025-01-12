return {
  "stevanmilic/nvim-lspimport",
  dev = true,
  lazy = true,
  -- setup = function()
  --   -- TOODO: Make optional
  --   require("null-ls").register {
  --     name = "autoimport",
  --     method = require("null-ls").methods.CODE_ACTION,
  --     filetypes = { "python" },
  --     -- TODO: Complete the code acitons generator
  --     -- generator = {
  --     --   fn = function(params)
  --     --     return {
  --     --       {
  --     --         title = 'add "hi mom"',
  --     --         action = function()
  --     --           local current_row = vim.api.nvim_win_get_cursor(0)[1]
  --     --           vim.api.nvim_buf_set_lines(0, current_row, current_row, true, { "hi mom" })
  --     --         end,
  --     --       },
  --     --     }
  --     --   end,
  --     -- },
  --   }
  -- end,
  keys = {
    -- Add a keymap to run the import command
    {
      "<leader>li",
      "<cmd>lua require('lspimport').import()<CR>",
      { noremap = true, silent = true },
      desc = "Auto-resovle imports",
    },
    {
      "<leader>lI",
      "<cmd>lua require('lspimport').import_all()<CR>",
      { noremap = true, silent = true },
      desc = "Resolve imports",
    },
  },
}
