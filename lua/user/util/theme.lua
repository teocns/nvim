local M = {}

-- Utilities for persisting themes across sessions on disk

function M.save(colorscheme)
  -- Saves selected colorscheme to file
  -- vim.cmd("colorscheme " .. colorscheme)
  -- JSON with current colorscheme and background
  local json_data = {
    colorscheme = colorscheme or vim.g.colors_name,
    -- background = vim.g.background,
  }
  local success, json = pcall(vim.fn.json_encode, json_data)
  if not success then return end
  local f = io.open(vim.fn.stdpath "data" .. "/.theme", "w")
  f:write(json)
  f:close()
end

function M.load()
  -- Loads colorscheme from file
  local f = io.open(vim.fn.stdpath "data" .. "/.theme", "r")
  if not f then return end
  local raw_data = f:read "*a"
  local success, json_data = pcall(vim.fn.json_decode, raw_data)
  f:close()
  if not success then return end
  return json_data
end

-- Loads colorscheme form file if it exists
function M.maybe_load()
  -- Loads colorscheme from file if it exists
  local json = M.load()
  if json and json.colorscheme then
    -- Ensure it's not the same as the current colorscheme
    if vim.g.colors_name == json.colorscheme and vim.g.background == json.background then return end
    -- Also checks that hte colorscheme is valid before actually loading it
    if vim.fn.exists "colors_name" == 1 then
      if vim.fn.index(vim.fn.getcompletion("", "color"), json.colorscheme) ~= -1 then
        vim.cmd("colorscheme " .. json.colorscheme)
        if json.background then vim.g.background = json.background end
      end
    end
  end
end
--
--- @param colorscheme string
--- @param opts table | nil
function M.on_change(colorscheme, opts)
  -- Saves colorscheme to file on change
  opts = opts or {}
  if opts.autosave == nil then opts.autosave = true end
  if opts.apply then vim.cmd("colorscheme " .. colorscheme) end
  if opts.autosave then M.save(colorscheme) end
end

M.setup = function()
  vim.cmd [[ doautocmd User LazyLoadColorschemes ]]
  -- Load colorscheme from file if it exists
  M.maybe_load()
end

return M
