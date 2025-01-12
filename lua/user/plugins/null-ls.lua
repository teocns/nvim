return {
  "nvimtools/none-ls.nvim",
  config = function(_, arg)
    -- config variable is the default configuration table for the setup function call
    -- print(_)
    -- print(arg)
    local opts = {}
    -- a +=1
    opts.root_dir = function()
      local found = require("null-ls.utils").root_pattern(
      -- "compile_commands.json",
        "pyproject.toml",
        "poetry.lock",
        "poetry.toml",
        "lazy_snapshot.lua",
        "package.json",
        "requirements.lock"
      -- ".git"
      )(vim.loop.cwd())
      -- require('astronvim.utils').notify(found or "not found")
      if not found then found = vim.loop.cwd() end
      return found
    end
    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Set log level to DEBUG for null-ls
    -- opts.debug = true
    -- opts.log_level = "debug"

    null_ls = require "null-ls"
    opts.sources = {
      null_ls.builtins.formatting.prettierd.with {
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.prettierrc.json",
        },
        extra_filetypes = { "toml" },
      },
    }
    null_ls.setup(opts)

    -- return config -- return final config table
  end,
}
