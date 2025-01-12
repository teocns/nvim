return {
  "yetone/avante.nvim",
  lazy = true,
  enabled =false,
  cmd = {
    "AvanteAsk",
    "AvanteEdit", 
    "AvanteToggle",
    "AvanteRefresh",
  },
  -- enabled = false,
  -- lazy = false,
  -- version = false, -- set this if you want to always pull the latest change
  build = "make BUILD_FROM_SOURCE=true",
  -- build = "make",
  -- dev = true,
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  },
  -- init = function() require("avante_lib").load() end,
  -- config = function(_, opts)
  --   require("avante_lib").load()
  --
  --   require("avante").setup(opts)
  -- end,
  opts = {
    --     debug = false,
    --     ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | [string]
    -- provider = "claude", -- Only recommend using Claude
    -- auto_suggestions_provider = "claude",
    provider = "openai",
    
    --     ---@alias Tokenizer "tiktoken" | "hf"
    --     -- Used for counting tokens and encoding text.
    --     -- By default, we will use tiktoken.
    --     -- For most providers that we support we will determine this automatically.
    --     -- If you wish to use a given implementation, then you can override it here.
    --     tokenizer = "tiktoken",
    --     ---@alias AvanteSystemPrompt string
    --     -- Default system prompt. Users can override this with their own prompt
    --     -- You can use `require('avante.config').override({system_prompt = "MY_SYSTEM_PROMPT"}) conditionally
    --     -- in your own autocmds to do it per directory, or that fit your needs.
    --     system_prompt = [[
    -- You are an excellent programming expert.
    -- ]],

    -- find whether whenever 
    --     ---@type AvanteSupportedProvider
    openai = {
      endpoint = "https://api.openai.com/v1",
      -- model = "gpt-4o-2024-08-06",
      model = "gpt-4o",
      timeout = 15000, -- Timeout in milliseconds
      temperature = 0.1,
      max_tokens = 2048,
      -- ["local"] = false,
    },
    ---@type AvanteSupportedProvider
    -- copilot = {
    --   endpoint = "https://api.githubcopilot.com",
    --   model = "gpt-4o-2024-05-13",
    --   proxy = nil, -- [protocol://]host[:port] Use this proxy
    --   allow_insecure = true, -- Allow insecure server connections
    --   timeout = 30000, -- Timeout in milliseconds
    --   temperature = 0.1,
    --   max_tokens = 4096,
    -- },
    --     ---@type AvanteAzureProvider
    --     azure = {
    --       endpoint = "", -- example: "https://<your-resource-name>.openai.azure.com"
    --       deployment = "", -- Azure deployment name (e.g., "gpt-4o", "my-gpt-4o-deployment")
    --       api_version = "2024-06-01",
    --       timeout = 30000, -- Timeout in milliseconds
    --       temperature = 0,
    --       max_tokens = 4096,
    --       ["local"] = false,
    --     },
    --     ---@type AvanteSupportedProvider
    -- claude = {
    --   endpoint = "https://api.anthropic.com",
    --   model = "claude-3-5-sonnet-20240620",
    --   timeout = 30000, -- Timeout in milliseconds
    --   temperature = 0,
    --   max_tokens = 8000,
    --   -- ["local"] = false,
    -- },
    --     ---@type AvanteSupportedProvider
    --     gemini = {
    --       endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
    --       model = "gemini-1.5-flash-latest",
    --       timeout = 30000, -- Timeout in milliseconds
    --       temperature = 0,
    --       max_tokens = 4096,
    --       ["local"] = false,
    --     },
    --     ---@type AvanteSupportedProvider
    --     cohere = {
    --       endpoint = "https://api.cohere.com/v1",
    --       model = "command-r-plus-08-2024",
    --       timeout = 30000, -- Timeout in milliseconds
    --       temperature = 0,
    --       max_tokens = 4096,
    --       ["local"] = false,
    --     },
    --     ---To add support for custom provider, follow the format below
    --     ---See https://github.com/yetone/avante.nvim/README.md#custom-providers for more details
    --     ---@type {[string]: AvanteProvider}
    -- vendors = {
    --   ollama = {
    --     ["local"] = true,
    --     endpoint = "127.0.0.1:11434/v1",
    --     model = "llama3.2:latest",
    --     parse_curl_args = function(opts, code_opts)
    --       return {
    --         url = opts.endpoint .. "/chat/completions",
    --         headers = {
    --           ["Accept"] = "application/json",
    --           ["Content-Type"] = "application/json",
    --           ["x-api-key"] = "ollama",
    --         },
    --         body = {
    --           model = opts.model,
    --           messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
    --           max_tokens = 2048,
    --           stream = true,
    --         },
    --       }
    --     end,
    --     parse_response_data = function(data_stream, event_state, opts)
    --       require("avante.providers").openai.parse_response(data_stream, event_state, opts)
    --     end,
    --   },
    -- },
    --     ---Specify the behaviour of avante.nvim
    --     ---1. auto_apply_diff_after_generation: Whether to automatically apply diff after LLM response.
    --     ---                                     This would simulate similar behaviour to cursor. Default to false.
    --     ---2. auto_set_keymaps                : Whether to automatically set the keymap for the current line. Default to true.
    --     ---                                     Note that avante will safely set these keymap. See https://github.com/yetone/avante.nvim/wiki#keymaps-and-api-i-guess for more details.
    --     ---3. auto_set_highlight_group        : Whether to automatically set the highlight group for the current line. Default to true.
    --     ---4. support_paste_from_clipboard    : Whether to support pasting image from clipboard. This will be determined automatically based whether img-clip is available or not.
    behaviour = {
      -- auto_suggestions = true, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },
    --     history = {
    --       storage_path = vim.fn.stdpath "state" .. "/avante",
    --       paste = {
    --         extension = "png",
    --         filename = "pasted-%Y-%m-%d-%H-%M-%S",
    --       },
    --     },
    --     highlights = {
    --       ---@type AvanteConflictHighlights
    --       diff = {
    --         current = "DiffText",
    --         incoming = "DiffAdd",
    --       },
    --     },
    --     mappings = {
    --       ---@class AvanteConflictMappings
    --       diff = {
    --         ours = "co",
    --         theirs = "ct",
    --         all_theirs = "ca",
    --         both = "cb",
    --         cursor = "cc",
    --         next = "]x",
    --         prev = "[x",
    --       },
    --       suggestion = {
    --         accept = "<M-l>",
    --         next = "<M-]>",
    --         prev = "<M-[>",
    --         dismiss = "<C-]>",
    --       },
    --       jump = {
    --         next = "]]",
    --         prev = "[[",
    --       },
    --       submit = {
    --         normal = "<CR>",
    --         insert = "<C-s>",
    --       },
    --       -- NOTE: The following will be safely set by avante.nvim
    --       ask = "<leader>aa",
    --       edit = "<leader>ae",
    --       refresh = "<leader>ar",
    --       toggle = {
    --         default = "<leader>at",
    --         debug = "<leader>ad",
    --         hint = "<leader>ah",
    --         suggestion = "<leader>as",
    --       },
    --     },
    windows = {
      --       ---@alias AvantePosition "right" | "left" | "top" | "bottom"
      --       position = "right",
      --       wrap = true, -- similar to vim.o.wrap
      width = 40, -- default % based on available width in vertical layout
      --       height = 30, -- default % based on available height in horizontal layout
      --       sidebar_header = {
      --         align = "center", -- left, center, right for title
      --         rounded = true,
      --       },
      --       input = {
      --         prefix = "> ",
      --       },
      --       edit = {
      --         border = "rounded",
      --       },
    },
    --     --- @class AvanteConflictConfig
    --     diff = {
    --       autojump = true,
    --     },
    --     --- @class AvanteHintsConfig
    hints = {
      enabled = false,
    },
  },

  keys = {
    {
      "<D-l>",
      "<cmd>AvanteAsk<CR>",
      desc = "Avante: ask",
      mode = { "n", "v" },
      noremap = true,
    },
    {
      "<D-k>",
      "<cmd>AvanteEdit<CR>",
      -- function()
      --   -- Verify if there's any selection, otherwise, automatically select block
      --   local mode = vim.api.nvim_get_mode().mode
      --   if not (mode == "v" or mode == "V") then
      --     -- Automatically select the current block
      --     vim.cmd "normal! V"
      --   end
      --   -- Toggle the avante plugin
      --   require("avante").toggle()
      -- end,
      desc = "Avante: edit",
      mode = { "n", "v" },
      noremap = true,
    },
  },
}
