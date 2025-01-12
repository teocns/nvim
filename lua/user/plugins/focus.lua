return {
  "nvim-focus/focus.nvim",
  keys = {
    { "<C-w>" },
    -- { "\\"},
    -- { "|"},
    { "<leader>w" },
    { "<leader>uf", desc = "Focus settings" },
    { "<leader>uff", "<cmd>FocusToggle<CR>", desc = "Toggle Focus" },
    -- Disable for buffer
    { "<leader>ufdb", "<cmd>FocusDisableBuffer<CR>", desc = "Disable focus buffer" },
  },
  init = function(opts)
    local ignore_filetypes = { "toggleterm", "TelescopePrompt", "neo-tree", "Trouble" }
    local ignore_buftypes =
      { "nofile", "prompt", "popup", "quickfix", "terminal", "toggleterm", "TelescopePrompt", "trouble", "neo-tree" }
    local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

    vim.api.nvim_create_autocmd("WinEnter", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
          vim.w.focus_disable = true
        else
          vim.w.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for BufType",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.focus_disable = true
        else
          vim.b.focus_disable = false
        end
      end,
      desc = "Disable focus autoresize for FileType",
    })
  end,
  opts = {
    enable = true,
    autoresize = {
      width = 80,
      -- height = 
    },
    ui = {
      signcolumn = false,
      relativenumber = false,
      hybridnumber = false,
      winhighlight = true
    },
    -- split = {
    --
    --   tmux = true,
    -- },
  },
}
