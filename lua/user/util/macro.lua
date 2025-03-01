local M = {}

function M.better_search(key)
  return function()
    -- attempt to search
    local searched, error =
      pcall(vim.cmd.normal, { args = { (vim.v.count > 0 and vim.v.count or "") .. key }, bang = true })
    -- if search successful
    if searched then
      -- center and unfold with protection from errors
      pcall(vim.cmd.normal, "zzzv")
      -- set hlsearch to true
      vim.opt.hlsearch = true
    end
  end
end

function M.diagnostics_next()
  local row, _ = vim.diagnostics.get_next_pos()
  vim.cmd(row)
end

function M.diagnostics_prev()
  local row, _ = vim.diagnostics.get_prev_pos()
  vim.cmd(row)
end

return M
