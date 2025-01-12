return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- enabled = false,
  cmd = "Trouble",
  opts = {
    win = {
      position = "right",
      width = 80,
      pinned=true,
    },
  },
  keys = {
    -- Lua
    { "<leader>q", desc = "QF Trouble" },
    { "<leader>qt", function() require("trouble").toggle() end, desc = "Trouble" },
    {
      "<leader>qw",
      function() require("trouble").toggle "workspace_diagnostics" end,
      desc = "Workspace Diagnostics",
    },
    {
      "<leader>qd",
      function() require("trouble").toggle "document_diagnostics" end,
      desc = "Document Diagnostics",
    },
    { "<leader>qq", function() require("trouble").toggle "quickfix" end, desc = "Quickfix" },
    { "<leader>ql", function() require("trouble").toggle "loclist" end, desc = "Location List" },
    { "<leader>qr", function() require("trouble").toggle "lsp_references" end, desc = "lsp_references" },
    { "<leader>qd", function() require("trouble").toggle "lsp_definitions" end, desc = "lsp_definitions" },
    { "<leader>qs", function() require("trouble").toggle "symbols" end, desc = "lsp_definitions" },
    { "<leader>qj", function() require("trouble").toggle "jumplist" end, desc = "lsp_definitions" },
  },
  init = function()
    -- allow deleting
    -- delete one entry pressing d
    -- delete all entries in a file pressing d on the file
    -- delete all entries pressing D
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "Trouble",
      callback = function(event)
        if require("trouble.config").mode ~= "telescope" then return end

        local function delete()
          local folds = require "trouble.folds"
          local telescope = require "trouble.providers.telescope"

          local ord = { "" } -- { filename, ... }
          local files = { [""] = { 1, 1, 0 } } -- { [filename] = { start, end, start_index } }
          for i, result in ipairs(telescope.results) do
            if files[result.filename] == nil then
              local next = files[ord[#ord]][2] + 1
              files[result.filename] = { next, next, i }
              table.insert(ord, result.filename)
            end
            if not folds.is_folded(result.filename) then files[result.filename][2] = files[result.filename][2] + 1 end
          end

          local line = unpack(vim.api.nvim_win_get_cursor(0))
          for i, id in ipairs(ord) do
            if line == files[id][1] then -- Group
              local next = ord[i + 1]
              for _ = files[id][3], next and files[next][3] - 1 or #telescope.results do
                table.remove(telescope.results, files[id][3])
              end
              break
            elseif line <= files[id][2] then -- Item
              table.remove(telescope.results, files[id][3] + (line - files[id][1]) - 1)
              break
            end
          end

          if #telescope.results == 0 then
            require("trouble").close()
          else
            require("trouble").refresh { provider = "telescope", auto = false }
          end
        end
        vim.keymap.set("n", "x", delete, { buffer = event.buf })
        vim.keymap.set("n", "d", delete, { buffer = event.buf })
      end,
    })
  end,
}
