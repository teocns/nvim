-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    -- event = { 'BufReadPre', 'BufNewFile' },
    opts = function(_, _opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it

      _opts.ensure_installed = require("astronvim.utils").list_insert_unique(_opts.ensure_installed, {
        "lua_ls",
        "pyright",
        "ruff_lsp",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "prettier",
        -- "black",
        -- "ruff_lsp",
        -- "eslint_d",
        "stylua",
        -- "mypy",
        -- "debugpy",
        -- "clang-format",
      })

      opts.border = "rounded"
      opts.debug = false
      opts.log_level = "warn"
      opts.update_in_insert = false
      opts.diagnostics_format = "[#{s} #{c}] #{m}"
      -- opts.sources = sources
      opts.default_timeout = 1000

      opts.automatic_installation = false
      opts.automatic_setup = true
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = vim.env.DAP ~= nil,
    config = function(_, opts)
      require("mason-nvim-dap").setup {
        automatic_installation = true,
        ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
          "python",
          -- "codelldb",
          -- "cpptools",
        }),
        handlers = {}, -- load default handlers
      }
    end,
  },
}
