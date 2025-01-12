local M = {}

M.LAST_WINDOW = nil

M.toggle_last_window = function()
  -- Gets the ID of the current window
  local current_window = vim.api.nvim_get_current_win()

  -- Check if the last_window is still a valid window
  if M.LAST_WINDOW and vim.api.nvim_win_is_valid(M.LAST_WINDOW) then
    -- Avoid toggling if we're already in the last_window (meaning, this is a subsequent key press)
    if current_window ~= M.LAST_WINDOW then
      -- Switch to the last window
      vim.api.nvim_set_current_win(M.LAST_WINDOW)
    end
  else
    -- If the last window is not valid, use the default <C-W>w behavior
    vim.api.nvim_command "wincmd w"
  end

  -- Set LAST_WINDOW to the current window (which is where we started before this toggle function ran)
  M.LAST_WINDOW = current_window
end

M.set_last_window = function()
  M.LAST_WINDOW = vim.api.nvim_get_current_win()
end
return M
