return {
  n = {
    ["<leader>fb"] = {
      function() require("telescope.builtin").buffers { sort_mru = true } end,
      desc = "Buffers",
    },
    ["<leader>cf"] = {
      function()
        local path = vim.fn.expand "%:p"
        vim.fn.setreg("+", path)
        vim.notify('Copied "' .. path .. '" to the clipboard!')
      end,
      desc = "Copy filename (abs)",
    },
    ["<leader>cF"] = {
      function()
        -- Get buffer filepath relative to current working directory
        local path = require("astronvim.utils.status.utils").get_relative_path(vim.fn.expand "%:p")
        vim.fn.setreg("+", path)
        vim.notify('Copied "' .. path .. '" to the clipboard!')
      end,
      desc = "Copy filename (rel)",
    },
    ["<leader>cd"] = {
      function()
        -- Copy the directory of the current buffer
        local cwd = vim.fn.expand "%:p:h"
        vim.fn.setreg("+", cwd)
        vim.notify('Copied "' .. cwd .. '" to the clipboard!')
      end,
      desc = "Copy file parent directory",
    },
    ["<leader>cD"] = {
      function()
        -- Copy the directory of the session project (CWD)
        local cwd = vim.fn.getcwd()
        vim.fn.setreg("+", cwd)
        vim.notify('Copied "' .. cwd .. '" to the clipboard!')
      end,
      desc = "Copy CWD",
    },

    ["<leader>cm"] = {
      function()
        local path = vim.fn.expand "%:~:."
        -- ocal path = vim.fn.expand "%:p"
        local module = path:gsub("/", "."):gsub("%.py", "")

        -- local module = path:gsub("/", "."):gsub("%.lua", "")
        vim.fn.setreg("+", module)
        vim.notify('Copied "' .. module .. '" to the clipboard!')
      end,

      desc = "Copy dotted module path",
    },
  },
}
