return {
  "Saghen/blink.cmp",
  event = "InsertEnter",
  version = '*', -- This will automatically download prebuilt binary from latest release
  opts = {
    fuzzy = {
      use_frecency = false,
      use_proximity = false,
    },
    keymap = { 
      preset = 'super-tab',
      -- Custom keymaps to match your previous nvim-cmp setup
      ['<M-Space>'] = { 'show', 'show_documentation' },
      -- ['<Tab>'] = { 'select_next', 'fallback' },
      -- ['<S-Tab>'] = { 'select_prev', 'fallback' },
      -- ['<CR>'] = { 'accept', 'fallback' },
      -- ['<Esc>'] = { 'cancel', 'fallback' },
      -- ['<C-e>'] = { 'cancel', 'fallback' },
    },


    completion = {
      -- Similar to your nvim-cmp preselect setting
    -- or set either per mode via a function
      list = { 
        selection = {
          preselect = function(ctx)
            if vim.fn.getcmdtype() ~= '' then
              return false
            end
            return true
          end,
          auto_insert = function(ctx)
            if vim.fn.getcmdtype() ~= '' then
              return false
            end
            return true
          end
        }
      },
      
      -- Similar to your nvim-cmp window settings
      menu = {
        -- border = 'single',  -- More compact border
        auto_show = true,   -- Enable auto-show
        draw = {
          columns = {
            { "kind_icon", gap = 1 },
            { "label", gap = 1 },
            { "label_description", gap = 1 }, 
            { "source_name" }
          },
        },
      },

      -- Configure trigger settings for auto-completion
      trigger = {
        show_on_keyword = true,            -- Show after typing a keyword character
        show_on_trigger_character = true,   -- Show on trigger characters (like '.')
        prefetch_on_insert = true,         -- Prefetch completions when entering insert mode
        show_in_snippet = true,            -- Show completions while in snippets
      },

      accept = { auto_brackets = { enabled = false }, },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },

    -- Enable experimental signature help
    signature = { 
      enabled = true,
    },
  },
  opts_extend = { "sources.default" }
} 
