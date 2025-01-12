local M = {}

-- Function to apply changes from quickfix list
function M.apply_quickfix_changes()
  local qflist = vim.fn.getqflist()
  for _, entry in ipairs(qflist) do
    vim.cmd('tabnew')
    vim.cmd('edit ' .. entry.filename)
    vim.cmd('diffthis')
    vim.cmd('vsplit')
    vim.cmd('edit ' .. entry.filename)
    vim.cmd('diffthis')
  end
end

-- Map C-Y to accept changes in diff mode
vim.api.nvim_set_keymap('n', '<C-Y>', ':diffput<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Y>', ':diffget<CR>', { noremap = true, silent = true })

return M
