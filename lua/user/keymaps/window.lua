return {
  n = {
    -- Quit window
    ["<leader>wq"] = {
      function() vim.api.nvim_command "q" end,
      desc = "Quit window",
    },
    ["<leader>ws"] = {
      "<cmd>windo set scrollbind!<CR>",
      desc = "Toggle scrollbind",
    },
    ["<leader>wr"] = {
      "<cmd>SmartResizeMode<CR>",
      desc = "Smart resize mode",
    },
    ["<leader>wgd"] = {
      -- Open definition in split window pane
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local cmd = string.format("split +%d %s", row, bufname)
        vim.api.nvim_command(cmd)
      end,
      desc = "Open definition in split window pane. ",
    },
    -- Close tab
    ["<leader>tq"] = {
      "<cmd>tabclose<CR>",
      desc = "Close tab",
    },

    ["<leader>tQ"] = {
      desc = "Close tab and its buffers",
      "<cmd>windo bd<CR>",
    },
    -- New tab
    ["<leader>tn"] = {
      "<cmd>tabnew<CR>",
      desc = "New tab",
    },
    ["<leader>tcd"] = {
      function()
        local buffer = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buffer)
        local cwd = vim.fn.fnamemodify(bufname, ":h")
        vim.api.nvim_command("tcd " .. cwd)
      end,
      desc = "Change tab's CWD to current buffer's directory",
    },
    ["tt"] = { "<cmd>tabnew<CR>", desc = "Cycle through tabs" },
  },
}
