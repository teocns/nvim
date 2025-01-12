local lspkind_comparator = function(conf)
  local lsp_types = require("cmp.types").lsp.CompletionItemKind
  return function(entry1, entry2)
    -- if entry1.source.name ~= "nvim_lsp" then
    --   if entry2.source.name == "nvim_lsp" then
    --     return false
    --   else
    --     return nil
    --   end
    -- end

    -- local ctx = require("cmp.config.context")
    -- -- Prioritise context. function arguments for example
    -- local in_capture = ctx.in_treesitter_capture
    -- if in_capture(entry1:get_kind()) then return true end
    -- if in_capture(entry2:get_kind()) then return false end

    local kind1 = lsp_types[entry1:get_kind()]
    local kind2 = lsp_types[entry2:get_kind()]
    if kind1 == "Variable" and entry1:get_completion_item().label:match "%w*=" then kind1 = "Parameter" end
    if kind2 == "Variable" and entry2:get_completion_item().label:match "%w*=" then kind2 = "Parameter" end

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then return nil end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2) return entry1.completion_item.label < entry2.completion_item.label end

return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      -- "lukas-reineke/cmp-under-comparator",
    },
    event = "InsertEnter",
    opts = function()
      local cmp = require "cmp"
      local cmp_types = require "cmp.types"
      local lspkind_status_ok, lspkind = pcall(require, "lspkind")
      local utils = require "astronvim.utils"
      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      return {
        enabled = function()
          local dap_prompt = utils.is_available "cmp-dap" -- add interoperability with cmp-dap
            and vim.tbl_contains(
              { "dap-repl", "dapui_watches", "dapui_hover" },
              vim.api.nvim_get_option_value("filetype", { buf = 0 })
            )
          if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" and not dap_prompt then return false end
          return vim.g.cmp_enabled
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          -- format = function(entry, vim_item)
          --   vim_item.menu = entry:get_completion_item().detail
          --   return vim_item
          -- end,
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format { mode = "symbol_text", maxwidth = 30 }(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            -- kind.abbr = kind.abbr .. " "
            return kind
          end,
          -- format = lspkind_status_ok and lspkind.cmp_format(utils.plugin_opts "lspkind.nvim") or nil,
          menu = {
            buffer = "[Buf]",
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
          },
        },
        duplicates = {
          nvim_lsp = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        snippet = {
          expand = function(args)
            -- Insert args.body as regular text
            -- No snippet happening here
            vim.api.nvim_feedkeys(args.body, "i", false)
          end,
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          -- ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          -- ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<M-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          -- ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          -- { name = "codeium", keyword_length = 0, priority = 1000 },

          { name = "nvim_lsp", keyword_length = 1 },
          -- { name = "cmp_tabnine", keyword_length = 3 },
          -- { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          -- { name = "buffer", priority = 500 },
          {
            name = "buffer",
            keyword_length = 1,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
        },
        { name = "path" },
        sorting = {
          comparators = {

            lspkind_comparator {
              kind_priority = {
                Parameter = 14,
                -- Variable = 13,
                -- Field = 12,
                -- Property = 11,
                -- Constant = 10,
                -- Enum = 10,
                -- EnumMember = 10,
                -- Event = 10,
                -- Function = 10,
                -- Method = 10,
                -- Operator = 10,
                -- Reference = 10,
                -- Struct = 10,
                -- File = 8,
                -- Folder = 8,
                -- Class = 5,
                -- Color = 5,
                -- Module = 5,
                -- Keyword = 2,
                -- Constructor = 1,
                -- Interface = 1,
                -- Snippet = 0,
                Text = -1,
                -- TypeParameter = 1,
                -- Unit = 1,
                -- Value = 1,
              },
            },

            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.scopes,
            cmp.config.compare.score,
            -- label_comparator,
            cmp.config.compare.kind,

            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.length,
            cmp.config.compare.order,
            -- -- require("cmp-under-comparator").under,
          },
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = true,
        },
        -- completion = {
        --   keyword_length = 1,
        --   autocomplete = {
        --     cmp_types.cmp.TriggerEvent.TextChanged
        --   },
        -- },
      }
    end,
  },
}
