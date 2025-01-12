return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "User LazyLoadColorschemes",
  },
  {
    "lunarvim/darkplus.nvim",
    name = "darkplus",
    event = "User LazyLoadColorschemes",
  },
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    opts = {
      style = "deep",
      toggle_style_key = "<leader>ts",
      -- highlights = {
      --   ["PMenuSel"] = {
      --     bg = "#528BFF",
      --     fg = "#000000",
      --   },
      -- },
    },
    event = "User LazyLoadColorschemes",
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    -- opts = {
    --   on_highlights = function(hl, c)
    --     local prompt = "NONE"
    --     hl.TelescopeNormal = {
    --       bg = c.bg_dark,
    --       fg = c.fg_dark,
    --     }
    --     hl.TelescopeBorder = {
    --       bg = c.bg_dark,
    --       fg = c.bg_dark,
    --     }
    --     hl.TelescopePromptNormal = {
    --       bg = prompt,
    --     }
    --     hl.TelescopePromptBorder = {
    --       bg = prompt,
    --       fg = prompt,
    --     }
    --     hl.TelescopePromptTitle = {
    --       bg = prompt,
    --       fg = prompt,
    --     }
    --     hl.TelescopePreviewTitle = {
    --       bg = c.bg_dark,
    --       fg = c.bg_dark,
    --     }
    --     hl.TelescopeResultsTitle = {
    --       bg = c.bg_dark,
    --       fg = c.bg_dark,
    --     }
    --     -- Disable line cross cursor highlight
    --     hl.CursorLine = {
    --       bg = "NONE"
    --     }
    --   end,
    -- },
    event = "User LazyLoadColorschemes",
  },
  -- {
  --   "chuling/equinusocio-material.vim",
  --   name = "material",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "lunarvim/synthwave84.nvim",
  --   name = "synthwave",
  --   event = "User LazyLoadColorschemes",
  -- },
  {
    "teocns/neovim-ayu",
    name = "ayu",
    event = "User LazyLoadColorschemes",
  },
  -- {
  --   "ayu-theme/ayu-vim",
  --   name = "ayu",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   name = "kanagawa",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "bluz71/vim-nightfly-colors",
  --   name = "nightfly",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "marko-cerovac/material.nvim",
  --   config = function()
  --     require("material").setup {
  --       high_visibility = {
  --         lighter = false, -- Enable higher contrast text for lighter style
  --         darker = false, -- Enable higher contrast text for darker style
  --       },
  --     }
  --   end,
  --   name = "cerovak-material",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   name = "nightfox",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   event = "User LazyLoadColorschemes",
  -- },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   name = "github",
  --   event = "User LazyLoadColorschemes",
  -- },
}
