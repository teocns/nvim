--- @class Shortcut
--- @field key any

local function splitChars(inputString)
  local charArray = {}
  for char in inputString:gmatch "." do
    table.insert(charArray, char)
  end
  return charArray
end
BIND_KEYS = splitChars "1234567890"
BIND_KEYS_REPLACE = splitChars "!@#$%^&*()"
-- local get_key = function()
--   -- Retrieve from cache first
--   local curpath = vim.fn.getcwd()
--   -- Special exception for .gchromium where we keep a global harpoon
--   if curpath:find ".gchromium/" then return "chromium" end
--   return require("null-ls.utils").root_pattern ".git"(vim.fn.getcwd()) or vim.fn.getcwd()
-- end
local hlist = function() return require("harpoon"):list() end

local function find_shortcut_index(shortcut_key)
  -- Element is a numerical string representing the key-index
  -- Find the index within the underlying indexed array
  -- local equals = require("harpoon").config.equals
  -- local index = 0

  -- Cros iterate bind keys
  for idx, item in pairs(hlist().items) do
    if shortcut_key == item.context.shortcut_key then return idx end
  end
end

local function make_shortcut_key(leader, key) return "<M-" .. tostring(key) .. ">" end
HARPOON_UI = {
  entry_displayer = function()
    return require("telescope.pickers.entry_display").create {
      separator = "  ",
      items = {
        { width = 5 },
        { remaining = true },
      },
    }
  end,
  entry_maker = function(entry)
    local line = entry.value .. ":" .. entry.context.row --- .. ":" .. entry.context.col | Let's not display the column
    local displayer = HARPOON_UI.entry_displayer()
    local make_display = function()
      return displayer {
        { entry.context.shortcut_key, "TelescopeResultsNumber" },
        line,
      }
    end
    return {
      value = entry,
      ordinal = line,
      display = make_display,
      lnum = entry.row,
      col = entry.col,
      filename = entry.context.abspath,
    }
  end,
  finder = function()
    local _items = {}
    for k, v in pairs(hlist().items) do
      table.insert(_items, v)
    end
    return require("telescope.finders").new_table { results = _items, entry_maker = HARPOON_UI.entry_maker }
  end,
  sorter = function() return require("telescope.config").values.generic_sorter {} end,
  previewer = function() return require("telescope.config").values.qflist_previewer {} end,
}

local telescope_entry_delete = function(prompt_bufnr)
  -- Works within telescope only
  local action_state = require "telescope.actions.state"
  local action_utils = require "telescope.actions.utils"

  local selection = action_state.get_selected_entry()
  if selection == nil then
    require("astronvim.utils").notify "No item selected"
    return
  end

  hlist():remove(selection.value)

  -- local selections = {}
  -- action_utils.map_selections(prompt_bufnr, function(entry) table.insert(results, entry) end)
  -- for _, current_selection in ipairs(selections) do
  --   hlist():remove(current_selection.value)
  --   print(string.format("Deleting selection mark: %s", current_selection.value))
  -- end

  local current_picker = action_state.get_current_picker(prompt_bufnr)
  -- Save the state of the current picker
  current_picker:refresh(HARPOON_UI.finder(), { reset_prompt = true })
end

local toggle_telescope = function()
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = HARPOON_UI.finder(),
      previewer = HARPOON_UI.previewer(),
      sorter = HARPOON_UI.sorter(),
      attach_mappings = function(_, map)
        map({ "i", "n" }, "<C-d>", telescope_entry_delete)
        return true
      end,
    })
    :find()
end

local get_root_dir = function() return require("null-ls.utils").root_pattern ".git"(vim.loop.cwd()) or vim.fn.getcwd() end
local create_entry = function(config, name, shortcut_key)
  if shortcut_key == nil then
    -- fall back to available harpoon keys
    for idx, key in pairs(BIND_KEYS) do
      local _shortcut = make_shortcut_key("M", key)
      if find_shortcut_index(_shortcut) == nil then
        shortcut_key = _shortcut
        break
      end
    end
  end
  local Path = require "plenary.path"
  local fallback_cfg = require("harpoon.config").get_default_config

  if config == nil then
    config = require("harpoon").config
    if config == nil then config = fallback_cfg() end
  end
  local function normalize_path(buf_name, root) return Path:new(buf_name):make_relative(root) end
  name = name or normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), get_root_dir())
  -- Print logs for the above goings
  -- print("nvim_buf_get_name: " .. vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
  -- print("config.get_root_dir(): " .. config.get_root_dir())
  local bufnr = vim.fn.bufnr(name, false)

  local pos = { 1, 0 }
  if bufnr ~= -1 then pos = vim.api.nvim_win_get_cursor(0) end

  return {
    value = name,
    context = {
      abspath = vim.fn.expand "%:p",
      shortcut_key = shortcut_key,
      row = pos[1],
      col = pos[2],
    },
  }
end

-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(hlist()) end, { desc = "Open harpoon window" })

__plugin__ = {
  "ThePrimeagen/harpoon",
  dev = true,
  dependencies = { "nvim-telescope/telescope.nvim" },
  branch = "harpoon2",
  config = function()
    require("harpoon"):setup {
      default = {
        select_with_nil = false,
        get_root_dir = get_root_dir,
        equals = function(a, b)
          if a == nil and b == nil then
            return true
          elseif a == nil or b == nil then
            return false
          end

          return a.context.shortcut_key == b.context.shortcut_key
          -- a.context.abspath == b.context.abspath
          -- and a.context.row == b.context.row
          -- and a.context.col == b.context.col
        end,
        create_list_item = create_entry,
        select = function(list_item, list, option)
          -- Open a buffer using the vim lua api
          -- local root= get_root_dir()
          if not list_item then
            require("astronvim.utils").notify "No item selected"
            -- pretty print the list
            -- print(vim.inspect(list))
          else
            -- vim.api.nvim_command("edit " .. list_item.context.abspath)
            -- Go exactly to the line and column using context.row and context.col
            -- Get the current window

            vim.api.nvim_command("e " .. list_item.context.abspath)

            local winnr = vim.api.nvim_get_current_win()

            pcall(vim.api.nvim_win_set_cursor, winnr, { list_item.context.row, list_item.context.col })
          end
        end,
      },
      settings = {
        sync_on_ui_close = false,
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,
        -- key = get_key,
      },
    }

    require("harpoon"):extend {
      ADD = function(evt)
        require("astronvim.utils").notify("Harpoon: + " .. evt.item.context.shortcut_key .. ": " .. evt.item.value)
      end,
      REPLACE = function(evt)
        require("astronvim.utils").notify("Harpoon: # " .. evt.item.context.shortcut_key .. ": " .. evt.item.value)
        require("harpoon"):sync()
      end,
      --   UI_CREATE = function(cx)
      --     -- vim.keymap.set({ "n", "i" }, "<C-d>", function()
      --     --   -- Clear the list
      --     --   hlist():clear()
      --     -- end, { buffer = cx.bufnr })
      --     vim.keymap.set({ "n", "i" }, "<C-d>", function()
      --       local action_state = require "telescope.actions.state"
      --       local current_picker = action_state.get_current_picker(cx.bufnr) -- picker state
      --       local entry = action_state.get_selected_entry()
      --       print(vim.inspect(entry))
      --       -- hlist():remove_at()
      --     end, { buffer = cx.bufnr })
      --     vim.keymap.set(
      --       "n",
      --       "<C-t>",
      --       function() require("harpoon").ui:select_menu_item { tabedit = true } end,
      --       { buffer = cx.bufnr }
      --     )
      --   end,
    }
  end,
  keys = {
    {
      "<leader>hh",
      toggle_telescope,
      desc = "Show harpoon menu",
    },
    {
      "<leader>ha",
      function() hlist():add() end,
      desc = "Add to harpoon",
    },
    {
      -- On ke-stroke M and minus sign. M-- won't work.
      "<M-_>",
      function() hlist():prev { ui_nav_wrap = true } end,
      -- function() require("harpoon.mark").add_file() end,
      desc = "Harpoon prev",
      -- noremap
      noremap = true,
    },
    {
      "<M-+>",
      function() hlist():next { ui_nav_wrap = true } end,
      -- function() require("harpoon.mark").add_file() end,
      desc = "Harpoon next",
      -- noremap
      noremap = true,
    },
  },
}

--[[
This loop will generate key mappings for `<M-0>` to `<M-9>`.
The `add_key_mapping` function is a placeholder for whatever function or method you use to add key mappings in your application.
Replace it with the appropriate function call.
]]

local leader = "M"
for idx = 1, #BIND_KEYS do
  local key = BIND_KEYS[idx]
  local shortcut_key = make_shortcut_key(leader, key)
  -- local replace_key = "<M-" .. shift_chars[idx] .. ">" -- +1 because lua is 1-indexed
  local replace_key = make_shortcut_key(leader, BIND_KEYS_REPLACE[idx])

  local desc = "Harpoon key " .. tostring(key)

  table.insert(__plugin__.keys, {
    shortcut_key,
    function() hlist():select(find_shortcut_index(shortcut_key)) end,
    desc = "Add " .. desc,
    noremap = true,
  })

  table.insert(__plugin__.keys, {
    replace_key,
    function()
      local replace_idx = find_shortcut_index(shortcut_key)
      local entry = create_entry(nil, nil, shortcut_key)
      if replace_idx ~= nil then
        -- No index found, add new entry instead
        hlist():replace_at(replace_idx, entry)
      else
        hlist():add(entry)
      end
    end,
    desc = "Replace " .. desc,
    noremap = true,
  })
end
return __plugin__
