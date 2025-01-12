-- return {}
return {
  n = {
    -- QUICKFIX
    ["<leader>qaf"] = {
      "<cmd>caddexpr expand('%:p')<CR>",
      desc = "Adds current buffer filepath to quickfix",
    },
    ["<leader>qo"] = {
      "<cmd>copen<CR>",
      desc = "Open quicklist",
    },
    ["<leader>qc"] = {
      "<cmd>cclose<CR>",
      desc = "Close quicklist",
    },
    ["<leader>qfw"] = {
      function()
        -- Get the list of files from qf
        local search_paths = vim.fn.getqflist()
        require("telescope.builtin").live_grep {
          prompt_title = "Search words in quickfix",
          search_dirs = search_paths,
        }
      end,
      desc = "Find words in qf files",
    },
    ["<leader>qfb"] = {
      "<cmd>QFFileContentsToBuff<CR>",
      desc = "Close quicklist",
    },
    ["<leader>qffb"] = {
      function()
        local filename = vim.fn.expand "%:p"
        if filename ~= nil and filename ~= "" then
          -- Get the file path relative to the current working directory
          local filepath = vim.fn.fnamemodify(filename, ":.")
          -- Read the file content
          local content = table.concat(vim.fn.readfile(filename), "\n")

          -- Insert the content into the buffer
          vim.api.nvim_buf_set_lines(0, -1, -1, false, { "# " .. filepath .. ":" })
          vim.api.nvim_buf_set_lines(0, -1, -1, false, { "```" })
          for _, line in ipairs(vim.split(content, "\n")) do
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { line })
          end
          vim.api.nvim_buf_set_lines(0, -1, -1, false, { "```", "" })
        end
      end,
      desc = "Inline absolute file paths into buffer",
    },

    ["<leader>qn"] = {
      "<cmd>cnext<CR>",
      desc = "Next quicklist",
    },
    ["<leader>qp"] = {
      "<cmd>cprev<CR>",
      desc = "Previous quicklist",
    },
    ["<leader>qm"] = {
      "<cmd>MarksQFListGlobal<CR>",
      desc = "Marks (global)",
    },
  },
}
