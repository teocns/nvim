return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "JoosepAlviste/nvim-ts-context-commentstring", commit = "6c30f3c8915d7b31c3decdfe6c7672432da1809d" },
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- HACK: remove when https://github.com/windwp/nvim-ts-autotag/issues/125 closed.
    -- { "windwp/nvim-ts-autotag", opts = { enable_close_on_slash = false } },
  },
  event = "User AstroFile",
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  build = ":TSUpdate",
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    -- Luckily, the only thins that those plugins need are the custom queries, which we make available
    -- during startup.
    -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
    require("lazy.core.loader").add_to_rtp(plugin)
    require "nvim-treesitter.query_predicates"
  end,
  opts = function()
    return {
      autotag = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      -- HACK: force install of shipped neovim parsers since TSUpdate doesn't correctly update them
      -- ensure_installed = {
      --   "awk",
      --   "bash",
      --   -- "c",
      --   -- "cmake",
      --   -- "cpp",
      --   "diff",
      --   "doxygen",
      --   "git_config",
      --   "gitattributes",
      --   "gitcommit",
      --   "gitignore",
      --   "go",
      --   "javascript",
      --   "jsdoc",
      --   "json",
      --   "json5",
      --   "jsonc",
      --   "lua",
      --   -- "luap",
      --   "luau",
      --   "make",
      --   "markdown",
      --   "markdown_inline",
      --   -- "objc",
      --   -- "org",
      --   "passwd",
      --   "python",
      --   "tsx",
      --   "typescript",
      --   "vim",
      --   "vimdoc",
      --   "yaml",
      -- },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
          return vim.b[bufnr].large_buf or ft == "query" or ft == "scm"
        end,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby", "markdown", "yaml"},
      },
      incremental_selection = {
        enable = true,
        keymaps = {

          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
          -- node_incremental = "[",
          -- node_decremental = "]",
        },
      },
      indent = { enable = true },
      textobjects = {
        lsp_interop = {
          enable = true,
          border = "single",
          floating_preview_opts = {},
          peek_definition_code = {
            ["gF"] = "@function.outer",
            ["gC"] = "@class.outer",
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            -- ["iC"] = { query = "@call.inner", desc = "inside call" },
            -- ["aC"] = { query = "@call.outer", desc = "around class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
            ["aC"] = { query = "@comment.outer", desc = "around comment" },
            -- ["ak"] = { query = "(string) @key", desc = "around comment" },

            -- ["iC"] = { query = "@comment.inner", desc = "inside comment" }, -- hello
            -- ["aS"] = { query = "@scope.outer", desc = "around scope" },
            -- ["iS"] = { query = "@scope.inner", desc = "inside scope" },
            -- -- Qualified Identifier
            -- ["aQ"] = {
            --   query = "((qualified_identifier) @capture (#nearest! @capture))",
            --   desc = "around nearest qualified identifier",
            -- },
            -- ["iQ"] = { query = "((qualified_identifier) @capture (#nearest! @capture))",
            --   desc = "inside nearest qualified identifier",
            -- },
            --
            -- -- Namespace Identifier
            -- ["aN"] = { query = "(namespace_identifier) @capture", desc = "around namespace identifier" },
            -- ["iN"] = { query = "(namespace_identifier) @capture", desc = "inside namespace identifier" },
            --
            -- -- Identifier
            -- ["aI"] = { query = "(identifier) @capture", desc = "around identifier" },
            -- ["iI"] = { query = "(identifier) @capture", desc = "inside identifier" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
    }
  end,
  config = require "plugins.configs.nvim-treesitter",
}
