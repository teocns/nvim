return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      inlay_hints = {
        only_current_line = true,
      },
    },
    init = function()
      -- load clangd extensions when clangd attaches
      local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Load clangd_extensions with clangd",
        callback = function(args)
          if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
            require "clangd_extensions"
            -- require("clangd_extensions.inlay_hints").setup_autocmd()
            -- require("clangd_extensions.inlay_hints").set_inlay_hints()

            -- add more `clangd` setup here as needed such as loading autocmds
            vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
          end
        end,
      })
    end,
  },
  -- {
  --   "arnamak/stay-centered.nvim",
  --   lazy = false,
  -- },
  -- {
  --   "eandrju/cellular-automaton.nvim",
  --   enabled - false,
  --   event = "VeryLazy",
  -- },
  -- {
  --   "jinh0/eyeliner.nvim",
  --   -- enabled = false,
  --   event = "BufEnter",
  --   opts = {
  --     highlight_on_key = true,
  --   },
  -- },
  {
    "kylechui/nvim-surround",
    -- dependencies = { "tpope/vim-repeat" },
    enabled = true,
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-y>s",
          insert_line = "<C-y>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "<C-y>S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      }
    end,
  },

  {
    "teocns/leap.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function(_, opts)
      local u_leap = require "leap.user"

      u_leap.create_default_mappings()
      u_leap.set_repeat_keys("<CR>", "<S-CR>", {
        relative_directions = true,
        modes = { "n", "x", "o" },
      })
    end,
  },
  {
    "kwkarlwang/bufjump.nvim",
    keys = {
      { "<C-n>", mode = { "n" }, desc = "Jump to next buffer" },
      { "<C-p>", mode = { "n" }, desc = "Jump to previous buffer" },
    },
    config = function()
      require("bufjump").setup {
        forward = "<C-n>",
        backward = "<C-p>",
        on_success = nil,
      }
    end,
  },
  {
    "AndrewRadev/splitjoin.vim",
    event = "User Astrofile",
    keys = {
      { "gS", mode = { "n", "v" }, desc = "Split line", silent = true, noremap = true, nowait = true },
      { "gJ", mode = { "n", "v" }, desc = "Join line",  silent = true, noremap = true, nowait = true },
    },
  },
  -- Lua
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>`", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode", mode = { "n" } },
    },
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = function()
          local percentage = 95
          local max_columns = vim.api.nvim_get_option "columns"
          return math.min(math.floor(percentage * max_columns), 140)
        end,        -- width of the Zen window
        height = 1, -- height of the Zen window
        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
          signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- tabline = 2,
          cursorline = false,   -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0",     -- disable fold column
          list = false,         -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          ruler = false,   -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0,                    -- turn off the statusline in zen mode
        },
        twilight = { enabled = false },      -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false },      -- disables git signs
        notifications = { enabled = false }, -- disables notifications
        -- disable indent-blankline
        ibl = {
          enabled = false,
        },
        indentblankline = {
          enabled = false,
        },
        ["indent-blankline"] = {
          enabled = false,
        },
        -- tmux = { enabled = false }, -- disables the tmux statusline
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
          enabled = false,
          font = "+3", -- font size increment
        },
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        -- alacritty = {
        --   enabled = false,
        --   font = "14", -- font size
        -- },
        -- -- this will change the font size on wezterm when in zen mode
        -- -- See alse also the Plugins/Wezterm section in this projects README
        -- wezterm = {
        --   enabled = false,
        --   -- can be either an absolute font size or the number of incremental steps
        --   font = "+4", -- (10% increase per step)
        -- },
      },
      config = function(_, opts)
        require("zen-mode").setup(opts)
        vim.cmd [[ doautocmd User LazyLoadWithZenMode ]]
      end,

      -- callback where you can add custom code when the Zen window opens
      on_open = function(win) end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function() end,
    },
  },
  -- Lua
  -- {
  --   "arnamak/stay-centered.nvim",
  --   event = "User Astrofile",
  --   config = function() require("stay-centered").setup() end
  -- }

  -- {
  --   "rktjmp/lush.nvim",
  --   cmd = { "LushRunTutorial" },
  -- },
}
