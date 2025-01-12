return {
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    "folke/neodev.nvim",
    lazy = true,
    ft = { "lua" },
    opts = {
      override = function(root_dir, library)
        for _, astronvim_config in ipairs(astronvim.supported_configs) do
          if root_dir:match(astronvim_config) then
            library.plugins = true
            break
          end
        end
        vim.b.neodev_enabled = library.enabled
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",

    -- opts = {
    --   basedpyright = {
    --     settings = {
    --       basedpyright = {
    --         analysis = {
    --           typeCheckingMode = "standard",
    --         },
    --       },
    --     },
    --   },
    -- },
    dependencies = {
      -- {
      --   "folke/neoconf.nvim",
      --   opts = function()
      --     local global_settings, file_found
      --     local _, depth = vim.fn.stdpath("config"):gsub("/", "")
      --     for _, dir in ipairs(astronvim.supported_configs) do
      --       dir = dir .. "/lua/user"
      --       if vim.fn.isdirectory(dir) == 1 then
      --         local path = dir .. "/neoconf.json"
      --         if vim.fn.filereadable(path) == 1 then
      --           file_found = true
      --           global_settings = path
      --         elseif not file_found then
      --           global_settings = path
      --         end
      --       end
      --     end
      --     return { global_settings = global_settings and string.rep("../", depth):sub(1, -2) .. global_settings }
      --   end,
      -- },
      {
        "williamboman/mason-lspconfig.nvim",
        cmd = { "LspInstall", "LspUninstall" },
        opts = function(_, opts)
          if not opts.handlers then opts.handlers = {} end
          opts.handlers[1] = function(server) require("astronvim.utils.lsp").setup(server) end
        end,
        config = require "plugins.configs.mason-lspconfig",
      },
    },
    cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
      if require("astronvim.utils").is_available "neoconf.nvim" then table.insert(cmds, "Neoconf") end
    end,
    event = "User AstroFile",
    config = require "plugins.configs.lspconfig",
  },
  {
    -- "jose-elias-alvarez/null-ls.nvim",
    "nvimtools/none-ls.nvim",
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
        opts = { handlers = {} },
      },
    },
    event = "User AstroFile",
    opts = function() return { on_attach = require("astronvim.utils.lsp").on_attach, log_level = "debug" } end,
  },
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    opts = {
      attach_mode = "global",
      backends = {
        ["_"] = { "lsp", "treesitter", "markdown", "man" },
        javascript = { "lsp", "treesitter" },
        python = { "lsp", "treesitter" },
        lua = { "lsp", "treesitter" },
      },
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
        "Field",
        "Property",
        "Constructor",
        "Enum",
        "Interface",
        "Struct",
      },
      -- post_parse_symbol = function(bufnr, item, ctx)
      --   if ctx.backend_name == "lsp" then
      --     if item.kind == "Function" or item.kind == "Method" then
      --       local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
      --       item.name = string.format("%s [%s]", item.name, filename)
      --     end
      --   end
      --   return true
      -- end,
      layout = {
        min_width = 30,
        max_width = 60,
        width = 40,
        default_direction = "right",
        placement = "edge",
        preserve_equality = true,
        resize_to_content = true,
        win_opts = {
          signcolumn = "no",
          foldcolumn = "0",
          winfixwidth = true,
          number = false,
          relativenumber = false,
          wrap = false,
        },
      },
      nav = {
        autojump = true,
        preview = true,
        -- border = "rounded",
        min_width = 30,
        max_width = 60,
        win_opts = {
          cursorline = true,
          winblend = 10,
          signcolumn = "no",
          foldcolumn = "0",
          winfixwidth = true,
          winfixheight = true,
        },
      },
      show_guides = true,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["<leader>ss"] = "actions.tree_toggle",
        ["<leader>sS"] = "actions.tree_toggle_recursive",
        ["gh"] = "actions.tree_close_recursive",
        ["gl"] = "actions.tree_open_recursive",
        ["?"] = "actions.show_help",
        ["<C-p>"] = "actions.preview",
        ["<C-v>"] = false,
        ["<C-s>"] = false,
      },
      highlight_mode = "split_width",
      highlight_closest = true,
      highlight_on_hover = true,
      highlight_on_jump = 400,
      close_on_select = false,
      close_automatic_events = {},
    },
  },
}
