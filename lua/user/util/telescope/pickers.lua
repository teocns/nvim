local M = {}

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

M.project_files = function(opts)
  opts = opts or {} -- define here if you want to define something

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system "git rev-parse --is-inside-work-tree"
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  local builtin = require "telescope.builtin"
  if is_inside_work_tree[cwd] then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end

M.old_files_sorted = function(opts)
  opts = opts or {}
  local builtin = require "telescope.builtin"

  local sorter = require("telescope.sorters").get_fzy_sorter()

  local fn = sorter.scoring_function

  sorter.scoring_function = function(_, prompt, line)
    local score = fn(_, prompt, line)

    return score > 0 and 1 or -1
  end

  local args = vim.tbl_extend("force", {
    sorter = sorter,
    tiebreak = function(current_entry, existing_entry, _) return current_entry.index > existing_entry.index end,
  }, opts)

  builtin.oldfiles(args)
end

return M
