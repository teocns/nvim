local M = {}

local is_busy = false
local timer = vim.loop.new_timer()

local function check_diagnostics()
  if is_busy then return end

  local diagnostics = vim.diagnostic.get(0)
  local count = {0, 0, 0, 0}

  for _, diagnostic in ipairs(diagnostics) do
    count[diagnostic.severity] = count[diagnostic.severity] + 1
  end

  local error_issues = count[vim.diagnostic.severity.ERROR]
  if error_issues > 0 then
    local error_messages = {}
    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        table.insert(error_messages, diagnostic.message)
      end
    end
    local context = table.concat(error_messages, "\n")
    require("CopilotChat").ask("Please assist with the following diagnostic issues:\n" .. context)
  end
end

function M.start()
  timer:start(0, 60000, vim.schedule_wrap(check_diagnostics)) -- Check every 60 seconds
end

function M.stop()
  timer:stop()
end

function M.set_busy(state)
  is_busy = state
  if state then
    M.stop()
    vim.defer_fn(function() M.set_busy(false) end, 30000) -- Reset busy state after 30 seconds
  else
    M.start()
  end
end

return M
