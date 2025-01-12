M = {}

function M.open_selected(prompt_bufnr)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local picker = action_state.get_current_picker(prompt_bufnr)
  -- local num_selections = table.getn(picker:get_multi_selection())
  -- local num_selections = #table

  if #picker:get_multi_selection() >= 1 then
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", ":e!", entry.value))
    end
    vim.cmd "stopinsert"
  else
    actions.file_edit(prompt_bufnr)
  end
end

-- Function to check if the input is a buffer ID
local function is_buffer_id(input)
  -- Check if input is a number
  if type(input) ~= "number" then return false end

  -- Check if the number is a valid buffer ID
  return vim.api.nvim_buf_is_valid(input)
end

-- Modified live_grep_selected function
function M.live_grep_selected(prompt_bufnr)
  local action_state = require "telescope.actions.state"
  local picker = action_state.get_current_picker(prompt_bufnr)
  local filetable = {}
  local hashlist = {}

  if #picker:get_multi_selection() >= 1 then
    for _, entry in ipairs(picker:get_multi_selection()) do
      local identifier = entry.value

      -- Check if identifier is a buffer ID
      if is_buffer_id(identifier) then
        -- Convert buffer ID to filename
        identifier = vim.api.nvim_buf_get_name(identifier)
      end

      if not hashlist[identifier] then
        hashlist[identifier] = true
        table.insert(filetable, identifier)
      end
    end
  end

  require("telescope.builtin").live_grep {
    search_dirs = filetable,
    prompt_title = "Live Grep (" .. #filetable .. " files)",
  }
end

function M.frecency(git)
  -- Fallback to git
  require("telescope").extensions.frecency.frecency { workspace = "CWD" }
  
  -- local root = string.gsub(vim.fn.system "git rev-parse --show-toplevel", "\n", "")
  -- if vim.v.shell_error == 0 then
  --   require("telescope").extensions.frecency.frecency { cwd = root, workspace = "CWD" }
  -- else
  --   require("telescope").extensions.frecency.frecency { workspace = "CWD" }
  -- end
end

return M
