-- Empty dummy command to trigger lazy load
vim.cmd [[ command! LazyLoadColorschemes :lua function() end ]]
vim.cmd [[ command! LazyLoadWithZenMode :lua function() end ]]

local function copy_qf_contents()
  -- Create a new buffer
  vim.api.nvim_command "enew"

  -- Retrieve the current quickfix list
  local current_qf_list = vim.fn.getqflist()

  -- Iterate over the quickfix list
  for _, qf in ipairs(current_qf_list) do
    -- Extract the filename from the text description
    local filename = string.match(qf.text, "^[^|]+")
    if filename ~= nil and filename ~= "" then
      -- Get the file path relative to the current working directory
      local filepath = vim.fn.fnamemodify(filename, ":.")
      -- Read the file content
      local content = table.concat(vim.fn.readfile(filename), "\n")

      -- Insert the content into the buffer
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "# " .. filepath .. ":" })
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "```" })
      for _, line in ipairs(vim.split(content, "\n")) do
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { line })
      end
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "```", "" })
    end
  end
end

-- Create the command
vim.api.nvim_create_user_command("QFFileContentsToBuff", copy_qf_contents, {})

local live_grep_qflist = function()
  local qflist = vim.fn.getqflist()
  local filetable = {}
  local hashlist = {}

  for _, value in pairs(qflist) do
    local name = vim.api.nvim_buf_get_name(value.bufnr)

    if not hashlist[name] then
      hashlist[name] = true
      table.insert(filetable, name)
    end
  end

  require("telescope.builtin").grep_string { search = "", search_dirs = filetable }
end

vim.api.nvim_create_user_command("QFLiveGrepFiles", live_grep_qflist, {})

local function copy_qf_filenames(opts)
  local separator = " "
  local qflist = vim.fn.getqflist()
  local filenames = {}

  for _, item in ipairs(qflist) do
    local filename = vim.fn.bufname(item.bufnr)
    if filename ~= "" and not vim.tbl_contains(filenames, filename) then
      table.insert(filenames, filename)
    end
  end

  if #filenames > 0 then
    local filenames_str = table.concat(filenames, separator)
    vim.fn.setreg("+", filenames_str)
    print("Copied filenames to clipboard.")
  else
    print("No filenames found in quickfix list.")
  end
end

vim.api.nvim_create_user_command("QFCopyFilenames", copy_qf_filenames, { nargs = "?" })
local remove_qf_item = function()
  local curqfidx = vim.fn.line "."
  local qfall = vim.fn.getqflist()

  -- Return if there are no items to remove
  if #qfall == 0 then return end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")

  -- Reopen quickfix window to refresh the list
  vim.cmd "copen"

  -- If not at the end of the list, stay at the same index, otherwise, go one up.
  local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)

  -- Set the cursor position directly in the quickfix window
  local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
  vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end

vim.api.nvim_create_user_command("QFRemoveItem", remove_qf_item, {})
vim.api.nvim_command "autocmd FileType qf nnoremap <buffer> dd :QFRemoveItem<cr>"

vim.api.nvim_create_user_command("Redir", function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
  vim.cmd "new"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })

-- Inline absolute quickfix list files to new buffer
local SymbolKind = {
  [1] = "File",
  [2] = "Module",
  [3] = "Namespace",
  [4] = "Package",
  [5] = "Class",
  [6] = "Method",
  [7] = "Property",
  [8] = "Field",
  [9] = "Constructor",
  [10] = "Enum",
  [11] = "Interface",
  [12] = "Function",
  [13] = "Variable",
  [14] = "Constant",
  [15] = "String",
  [16] = "Number",
  [17] = "Boolean",
  [18] = "Array",
  [19] = "Object",
  [20] = "Key",
  [21] = "Null",
  [22] = "EnumMember",
  [23] = "Struct",
  [24] = "Event",
  [25] = "Operator",
  [26] = "TypeParameter",
}

local function get_symbol_under_cursor()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, response, ctx, config)
    if err then
      print("Error retrieving symbols:", err)
      return
    end

    if not response or vim.tbl_isempty(response) then
      print "No response or empty response from LSP."
      return
    end

    local current_line = params.position.line
    local closest_symbol = nil
    local min_distance = math.huge

    local printSymbols = {}

    -- Function to recursively search for symbols in the response
    local function searchSymbols(symbols)
      for _, symbol in ipairs(symbols) do
        printSymbols[_] = symbol
        -- Check if the symbol is a class or function
        if symbol.kind == 5 or symbol.kind == 12 then
          local symbol_range = symbol.location and symbol.location.range or symbol.range
          if symbol_range then
            local symbol_line = symbol_range.start.line

            local distance = math.abs(symbol_line - current_line)
            if distance < min_distance then
              min_distance = distance
              closest_symbol = symbol
            end
          end
        end

        -- If the symbol has children, search them recursively
        if symbol.children then searchSymbols(symbol.children) end
      end
    end

    -- Start searching through the symbols
    searchSymbols(response)

    print(vim.inspect(printSymbols))
    if closest_symbol then
      print("Closest class/function: " .. closest_symbol.name)
    else
      print "No class/function found near cursor."
    end
  end)
end

-- exxpose get_symbol_under_cursor in global
-- vim.api.nvim_set_var('get_symbol_under_cursor', get_symbol_under_cursor)

vim.api.nvim_create_user_command("LSPCurrentSymbol", get_symbol_under_cursor, {})

vim.api.nvim_create_user_command("Cfdo", function(opts) vim.cmd("noautocmd cfdo " .. opts.args) end, { nargs = "+" })
vim.api.nvim_create_user_command("Wa", function(opts) vim.cmd("noautocmd wa") end, {})

-- Create a command to show the current buffer number

vim.api.nvim_create_user_command("Bufnr", function(opts)
  -- get the current buffer number
  print(vim.fn.bufnr())
end, {})

-- One for the buftype
vim.api.nvim_create_user_command("BufType", function(opts)
  -- print the buftype, filetype, etc
  print("buftype: " ..vim.bo.buftype .. "; filetype: " .. vim.bo.filetype)
end, {})
