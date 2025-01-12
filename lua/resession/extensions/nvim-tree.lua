return {
  on_save = function()
    -- Save nvim-tree bookmarks
    local api = require("nvim-tree.api")
    local marks = api.marks.list()
    local bookmark_paths = {}
    for _, node in pairs(marks) do
      table.insert(bookmark_paths, node.absolute_path)
    end
    return {
      bookmarks = bookmark_paths
    }
  end,
  on_load = function(data)
    -- Restore nvim-tree bookmarks
    if data.bookmarks then
      vim.g.nvim_tree_bookmarks = data.bookmarks
      -- Don't try to restore marks immediately - let the TreeAttachedPost event handle it
    end
  end
} 