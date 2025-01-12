--- ### AstroNvim LSP Utils
--
-- LSP related utility functions to use within AstroNvim and user configurations.
--
-- This module can be loaded with `local lsp_utils = require("astronvim.utils.lsp")`
--
-- @module astronvim.utils.lsp
-- @see astronvim.utils
-- @copyright 2022
-- @license GNU General Public License v3.0

local M = {}
local tbl_contains = vim.tbl_contains
local tbl_isempty = vim.tbl_isempty
local user_opts = astronvim.user_opts

local utils = require "astronvim.utils"
local conditional_func = utils.conditional_func
local is_available = utils.is_available
local extend_tbl = utils.extend_tbl

local server_config = "lsp.config."
local setup_handlers = user_opts("lsp.setup_handlers", {
  function(server, opts) require("lspconfig")[server].setup(opts) end,
})

M.diagnostics = { [0] = {}, {}, {}, {} }

M.setup_diagnostics = function(signs)
  local default_diagnostics = astronvim.user_opts("diagnostics", {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focused = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
  M.diagnostics = {
    -- diagnostics off
    [0] = extend_tbl(
      default_diagnostics,
      { underline = false, virtual_text = false, signs = false, update_in_insert = false }
    ),
    -- status only
    extend_tbl(default_diagnostics, { virtual_text = false, signs = false }),
    -- virtual text off, signs on
    extend_tbl(default_diagnostics, { virtual_text = false }),
    -- all diagnostics on
    default_diagnostics,
  }

  vim.diagnostic.config(M.diagnostics[vim.g.diagnostics_mode])
end

M.formatting = user_opts("lsp.formatting", { format_on_save = { enabled = true }, disabled = {} })
if type(M.formatting.format_on_save) == "boolean" then
  M.formatting.format_on_save = { enabled = M.formatting.format_on_save }
end

M.format_opts = vim.deepcopy(M.formatting)
M.format_opts.disabled = nil
M.format_opts.format_on_save = nil
M.format_opts.filter = function(client)
  local filter = M.formatting.filter
  local disabled = M.formatting.disabled or {}
  -- check if client is fully disabled or filtered by function
  return not (vim.tbl_contains(disabled, client.name) or (type(filter) == "function" and not filter(client)))
end

--- Helper function to set up a given server with the Neovim LSP client
---@param server string The name of the server to be setup
M.setup = function(server)
  -- if server doesn't exist, set it up from user server definition
  local config_avail, config = pcall(require, "lspconfig.server_configurations." .. server)
  if not config_avail or not config.default_config then
    local server_definition = user_opts(server_config .. server)
    if server_definition.cmd then require("lspconfig.configs")[server] = { default_config = server_definition } end
  end
  local opts = M.config(server)

  -- -- Add handlers for rename events
  -- opts.handlers = vim.tbl_extend("force", opts.handlers or {}, {
  --   ["workspace/willRenameFiles"] = function(err, result, ctx, config)
  --     -- Handle willRenameFiles event
  --     require('astronvim.utils').notify("Renaming files...", "info")
  --   end,
  --   ["workspace/didRenameFiles"] = function(err, result, ctx, config)
  --     -- Handle didRenameFiles event
  --     require('astronvim.utils').notify("...did rename files", "info")
  --   end,
  -- })

  local setup_handler = setup_handlers[server] or setup_handlers[1]
  if not vim.tbl_contains(astronvim.lsp.skip_setup, server) and setup_handler then setup_handler(server, opts) end
end

--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_active_clients.filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
function M.has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then return true end
  end
  return false
end

local function add_buffer_autocmd(augroup, bufnr, autocmds)
  if not vim.tbl_islist(autocmds) then autocmds = { autocmds } end
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if not cmds_found or vim.tbl_isempty(cmds) then
    vim.api.nvim_create_augroup(augroup, { clear = false })
    for _, autocmd in ipairs(autocmds) do
      local events = autocmd.events
      autocmd.events = nil
      autocmd.group = augroup
      autocmd.buffer = bufnr
      vim.api.nvim_create_autocmd(events, autocmd)
    end
  end
end

local function del_buffer_autocmd(augroup, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if cmds_found then vim.tbl_map(function(cmd) vim.api.nvim_del_autocmd(cmd.id) end, cmds) end
end

--- The `on_attach` function used by AstroNvim
---@param client table The LSP client details when attaching
---@param bufnr number The buffer that the LSP client is attaching to
M.on_attach = function(client, bufnr)
  local lsp_mappings = require("astronvim.utils").empty_map_table()

  lsp_mappings.n["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }
  lsp_mappings.n["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" }
  lsp_mappings.n["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" }
  lsp_mappings.n["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }

  if is_available "telescope.nvim" then
    lsp_mappings.n["<leader>lD"] =
      { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }
  end

  if is_available "mason-lspconfig.nvim" then
    lsp_mappings.n["<leader>Li"] = { "<cmd>LspInfo<cr>", desc = "LSP information" }
  end

  if is_available "none-ls.nvim" then
    lsp_mappings.n["<leader>LI"] = { "<cmd>NullLsInfo<cr>", desc = "Null-ls information" }
  end

  if client.supports_method "textDocument/codeAction" then
    lsp_mappings.n["<leader>la"] = {
      function() vim.lsp.buf.code_action() end,
      desc = "LSP code action",
    }
    lsp_mappings.v["<leader>la"] = {
      function() vim.lsp.buf.code_action() end,
      desc = "LSP code action (RANGE)",
    }
  end

  if client.supports_method "textDocument/codeLens" then
    add_buffer_autocmd("lsp_codelens_refresh", bufnr, {
      events = { "InsertLeave", "BufEnter" },
      desc = "Refresh codelens",
      callback = function()
        if not M.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
          del_buffer_autocmd("lsp_codelens_refresh", bufnr)
          return
        end
        if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
      end,
    })
    if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
    lsp_mappings.n["<leader>ll"] = {
      function() vim.lsp.codelens.refresh() end,
      desc = "LSP CodeLens refresh",
    }
    lsp_mappings.n["<leader>lL"] = {
      function() vim.lsp.codelens.run() end,
      desc = "LSP CodeLens run",
    }
  end

  if client.supports_method "textDocument/declaration" then
    lsp_mappings.n["gD"] = {
      function() vim.lsp.buf.declaration() end,
      desc = "Declaration of current symbol",
    }
  end

  if client.supports_method "textDocument/definition" then
    lsp_mappings.n["gd"] = {
      function() vim.lsp.buf.definition() end,
      desc = "Show the definition of current symbol",
      silent = true,
    }
  end

  if client.supports_method "textDocument/formatting" and not tbl_contains(M.formatting.disabled, client.name) then
    lsp_mappings.n["<leader>lf"] = {
      function() 
        vim.lsp.buf.format(M.format_opts)
      end,
      desc = "Format buffer",
      silent = true,
    }
    lsp_mappings.v["<leader>lf"] = lsp_mappings.n["<leader>lf"]

    vim.api.nvim_buf_create_user_command(
      bufnr,
      "Format",
      function() vim.lsp.buf.format(M.format_opts) end,
      { desc = "Format file with LSP" }
    )
    local autoformat = M.formatting.format_on_save
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    if
      autoformat.enabled
      and (tbl_isempty(autoformat.allow_filetypes or {}) or tbl_contains(autoformat.allow_filetypes, filetype))
      and (tbl_isempty(autoformat.ignore_filetypes or {}) or not tbl_contains(autoformat.ignore_filetypes, filetype))
    then
      add_buffer_autocmd("lsp_auto_format", bufnr, {
        events = "BufWritePre",
        desc = "autoformat on save",
        callback = function()
          if not M.has_capability("textDocument/formatting", { bufnr = bufnr }) then
            del_buffer_autocmd("lsp_auto_format", bufnr)
            return
          end
          local autoformat_enabled = vim.b.autoformat_enabled
          if autoformat_enabled == nil then autoformat_enabled = vim.g.autoformat_enabled end
          if autoformat_enabled and ((not autoformat.filter) or autoformat.filter(bufnr)) then
            vim.lsp.buf.format(extend_tbl(M.format_opts, { bufnr = bufnr }))
          end
        end,
      })
      lsp_mappings.n["<leader>uf"] = {
        function() require("astronvim.utils.ui").toggle_buffer_autoformat() end,
        desc = "Toggle autoformatting (buffer)",
      }
      lsp_mappings.n["<leader>uF"] = {
        function() require("astronvim.utils.ui").toggle_autoformat() end,
        desc = "Toggle autoformatting (global)",
      }
    end
  end

  -- Create a table to store timers
  local highlight_timers = {}

  if client.supports_method "textDocument/documentHighlight" then
    add_buffer_autocmd("lsp_document_highlight", bufnr, {
      {
        events = { "CursorHold" },  -- Removed CursorHoldI to reduce frequency
        desc = "highlight references when cursor holds",
        callback = function()
          if not M.has_capability("textDocument/documentHighlight", { bufnr = bufnr }) then
            del_buffer_autocmd("lsp_document_highlight", bufnr)
            return
          end
          -- Store timer in our separate table
          if not highlight_timers[bufnr] then
            highlight_timers[bufnr] = vim.loop.new_timer()
          end
          highlight_timers[bufnr]:start(150, 0, vim.schedule_wrap(function()
            vim.lsp.buf.document_highlight()
          end))
        end,
      },
      {
        events = { "CursorMoved", "BufLeave" },  -- Removed CursorMovedI
        desc = "clear references when cursor moves",
        callback = function() 
          if highlight_timers[bufnr] then
            highlight_timers[bufnr]:stop()
          end
          vim.lsp.buf.clear_references()
        end,
      },
    })
    
    -- Clean up timer when buffer is deleted
    vim.api.nvim_buf_attach(bufnr, false, {
      on_detach = function()
        if highlight_timers[bufnr] then
          highlight_timers[bufnr]:close()
          highlight_timers[bufnr] = nil
        end
      end,
    })
  end

  if client.supports_method "textDocument/hover" then
    -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
    if vim.fn.has "nvim-0.10" == 0 then
      lsp_mappings.n["K"] = {
        function() vim.lsp.buf.hover() end,
        desc = "Hover symbol details",
      }
    end
  end

  if client.supports_method "textDocument/implementation" then
    lsp_mappings.n["gI"] = {
      function() vim.lsp.buf.implementation() end,
      desc = "Implementation of current symbol",
    }
  end

  if client.supports_method "textDocument/inlayHint" then
    if vim.b.inlay_hints_enabled == nil then vim.b.inlay_hints_enabled = vim.g.inlay_hints_enabled end
    -- TODO: remove check after dropping support for Neovim v0.9
    if vim.lsp.inlay_hint then
      if vim.b.inlay_hints_enabled then vim.lsp.inlay_hint.enable(bufnr, true) end
      lsp_mappings.n["<leader>uH"] = {
        function() require("astronvim.utils.ui").toggle_buffer_inlay_hints(bufnr) end,
        desc = "Toggle LSP inlay hints (buffer)",
      }
    end
  end

  if client.supports_method "textDocument/references" then
    lsp_mappings.n["gr"] = {
      function() vim.lsp.buf.references() end,
      desc = "References of current symbol",
    }
    lsp_mappings.n["<leader>lR"] = {
      function() vim.lsp.buf.references() end,
      desc = "Search references",
    }
  end

  if client.supports_method "textDocument/rename" then
    lsp_mappings.n["<leader>lr"] = {
      function() vim.lsp.buf.rename() end,
      desc = "Rename current symbol",
    }
  end

  if client.supports_method "textDocument/signatureHelp" then
    lsp_mappings.n["<leader>lh"] = {
      function() vim.lsp.buf.signature_help() end,
      desc = "Signature help",
    }
  end

  if client.supports_method "textDocument/typeDefinition" then
    lsp_mappings.n["gy"] = {
      function() vim.lsp.buf.type_definition() end,
      desc = "Definition of current type",
    }
  end

  if client.supports_method "workspace/symbol" then
    lsp_mappings.n["<leader>lG"] = { function() vim.lsp.buf.workspace_symbol() end, desc = "Search workspace symbols" }
  end

  if client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens then
    if vim.g.semantic_tokens_enabled then
      vim.b[bufnr].semantic_tokens_enabled = true
      lsp_mappings.n["<leader>uY"] = {
        function() require("astronvim.utils.ui").toggle_buffer_semantic_tokens(bufnr) end,
        desc = "Toggle LSP semantic highlight (buffer)",
      }
    else
      client.server_capabilities.semanticTokensProvider = false
    end
  end

  if is_available "telescope.nvim" then -- setup telescope mappings if available
    if lsp_mappings.n.gd then lsp_mappings.n.gd[1] = function() require("telescope.builtin").lsp_definitions() end end
    if lsp_mappings.n.gI then
      lsp_mappings.n.gI[1] = function() require("telescope.builtin").lsp_implementations() end
    end
    if lsp_mappings.n.gr then
      lsp_mappings.n.gr[1] = function() require("telescope.builtin").lsp_references { include_declaration = false } end
    end
    if lsp_mappings.n["<leader>lR"] then
      lsp_mappings.n["<leader>lR"][1] = function()
        require("telescope.builtin").lsp_references {
          include_declaration = false,
          show_line = false,
        }
      end
    end
    if lsp_mappings.n.gy then
      lsp_mappings.n.gy[1] = function() require("telescope.builtin").lsp_type_definitions() end
    end
    if lsp_mappings.n["<leader>lG"] then
      lsp_mappings.n["<leader>lG"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
          if query then
            -- word under cursor if given query is empty
            if query == "" then query = vim.fn.expand "<cword>" end
            require("telescope.builtin").lsp_workspace_symbols {
              query = query,
              prompt_title = ("Find word (%s)"):format(query),
            }
          end
        end)
      end
    end
  end

  if client.name == "ruff_lsp" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
    -- Don't disable these as they provide code actions
    -- client.server_capabilities.diagnosticProvider = false
    -- client.server_capabilities["textDocument/publishDiagnostics"] = false
    
    -- Explicitly enable code actions
    client.server_capabilities.codeActionProvider = {
      resolveProvider = false
    }
  end

  if not vim.tbl_isempty(lsp_mappings.v) then
    lsp_mappings.v["<leader>l"] = { desc = utils.get_icon("ActiveLSP", 1, true) .. "LSP" }
  end
  utils.set_mappings(user_opts("lsp.mappings", lsp_mappings), { buffer = bufnr })

  for id, _ in pairs(astronvim.lsp.progress) do -- clear lingering progress messages
    if not next(vim.lsp.get_active_clients { id = tonumber(id:match "^%d+") }) then astronvim.lsp.progress[id] = nil end
  end

  local on_attach_override = user_opts("lsp.on_attach", nil, false)
  conditional_func(on_attach_override, true, client, bufnr)
end

if is_available('lsp_signature') then 

  require("lsp_signature").setup {
    bind = true,
    doc_lines = 5,
    floating_window = true,
    -- hint_enable = true,
    -- hint_prefix = ">",
    debug = false,
    handler_opts = { border = "single" },

	  hi_parameter = "Search",
	  hint_enable = true,
	  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
	  wrap = true,
	  zindex = 45, -- avoid overlap with nvim.cmp
    check_completion_visible = true,
    extra_trigger_chars = { "(", "," },
    toggle_key = "<M-x>",
    cycle_key = "<M-n>",
  }
end
--- The default AstroNvim LSP capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

-- Fix the definition capability structure
M.capabilities.textDocument.definition = {
  dynamicRegistration = true,
  linkSupport = true
}

M.capabilities.textDocument.synchronization = {
    dynamicRegistration = false,
    willSave = true,
    willSaveWaitUntil = true,
    didSave = true
}

-- Let blink.cmp enhance capabilities with proper structure
M.capabilities = require("blink.cmp").get_lsp_capabilities(M.capabilities)

M.flags = user_opts "lsp.flags"

--- Get the server configuration for a given language server to be provided to the server's `setup()` call
---@param server_name string The name of the server
---@return table # The table of LSP options used when setting up the given language server
function M.config(server_name)
  local server = require("lspconfig")[server_name]
  local lsp_opts = extend_tbl(server, { capabilities = M.capabilities, flags = M.flags })

  if server_name == "jsonls" then -- by default add json schemas
    local schemastore_avail, schemastore = pcall(require, "schemastore")
    if schemastore_avail then
      lsp_opts.settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } }
    end
  end
  if server_name == "yamlls" then -- by default add yaml schemas
    local schemastore_avail, schemastore = pcall(require, "schemastore")
    if schemastore_avail then lsp_opts.settings = { yaml = { schemas = schemastore.yaml.schemas() } } end
  end
  if server_name == "lua_ls" then -- by default initialize neodev and disable third party checking
    pcall(require, "neodev")
    lsp_opts.before_init = function(param, config)
      if vim.b.neodev_enabled then
        for _, astronvim_config in ipairs(astronvim.supported_configs) do
          if param.rootPath:match(astronvim_config) then
            table.insert(config.settings.Lua.workspace.library, astronvim.install.home .. "/lua")
            break
          end
        end
      end
    end
    lsp_opts.settings = { Lua = { workspace = { checkThirdParty = false } } }
  end

  local opts = user_opts(server_config .. server_name, lsp_opts)
  local old_on_attach = server.on_attach
  local user_on_attach = opts.on_attach
  opts.on_attach = function(client, bufnr)
    conditional_func(old_on_attach, true, client, bufnr)
    M.on_attach(client, bufnr)
    conditional_func(user_on_attach, true, client, bufnr)
  end
  return opts
end

return M
