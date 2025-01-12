vim.opt.clipboard = "unnamedplus"

require "user.commands"

return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = true,   -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "ayu",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = false,
  },

  lsp = {
    config = {
      clangd = {
        -- pass --background-index to clangd
        -- cmd = { "clangd", "--background-index=false", "--j=4","--log=error", "--pch-storage=disk" },
        cmd = {
          "~/.clangd/bin/clangd",
          "--log=error",
          "-j=12",
          "--function-arg-placeholders=true",
          "--all-scopes-completion=true",
          "--pch-storage=disk",
          "--enable-config",
          "--limit-results=7000",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      },
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false,    -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 2000, -- default format timeout
    },
    -- enable servers that you already have installed without mason
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = {
      enabled = false,
      lazy = true,
    },

    -- spec = {
    --   { import = "lazyvim.plugins.extras.vscode" },
    -- },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    require "user.autocmd"
    -- require("user.util.theme").setup()
    vim.filetype.add {
      extension = {
        gn = "gn",
        gni = "gn",
        tfvars = "terraform",
        mdx = "markdown", -- Use markdown syntax for MDX files
        -- No extension = shell script
      },
      pattern = {
        [".*%.j2"] = "jinja.yaml",
        [".*%.j2.*%."] = "jinja.yaml",
        ["justfile"] = "make",
        [".envrc"] = "sh",
      },
    }
  end,
}
