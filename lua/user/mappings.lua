local macro = require "user.util.macro"

-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-N>", { noremap = true, silent = true })

-- Make `gf` work in terminals
-- https://github.com/willothy/flatten.nvim/issues/85
vim.keymap.set("n", "gf", function()
  if vim.bo.buftype == "terminal" then
    -- if in a terminal, use flatten to open the file
    require("flatten.core").edit_files {
      files = { vim.fn.expand "<cfile>" },
      stdin = {},
      argv = {},
      guest_cwd = vim.fn.getcwd(),
      force_block = false,
      response_pipe = "",
    }
  else
    -- otherwise use original gf
    vim.cmd "normal! gf"
  end
end, { desc = "Open file" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Set [[ and ]] to switch tabs in normal mode
vim.keymap.set("n", "[[", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "]]", "<cmd>tabnext<CR>")

vim.keymap.set({ "i", "n", "v" }, "<F1>", "<cmd>Telescope<CR>")
vim.keymap.set({ "i", "n", "v" }, "<F2>", "<cmd>FzfLua<CR>")

-- Alt shift + ] to move tabs
vim.keymap.set({ "i", "n", "v" }, "<M-}>", "<cmd>tabnext<CR>")
vim.keymap.set({ "i", "n", "v" }, "<M-{>", "<cmd>tabprevious<CR>")
vim.keymap.set({ "n", "v", "x", "t" }, "<M-o>", "%")
vim.keymap.set({ "i" }, "<M-o>", "<C-o>%")

-- Move betwen tabs with
-- Motions!
-- Delete word
vim.keymap.set("i", "<M-BS>", "<C-W>")
-- vim.keymap.set("i", "<C-H>", "<C-W>")

-- CTRL ENTER goes to definition in a new tab
vim.keymap.set("n", "<C-CR>", ":lua vim.lsp.buf.definition()<CR>")

-- M + shift + [h,j,k,l] to resize splits just like arrows
vim.keymap.set("n", "<M-H>", "10<C-w>>")
vim.keymap.set("n", "<M-J>", "10<C-w>-")
vim.keymap.set("n", "<M-K>", "10<C-w>+")
vim.keymap.set("n", "<M-L>", "10<C-w><")

vim.keymap.set("x", "/", "<Esc>/\\%V") -- Pro visual selection search
vim.keymap.set({ "n", "v", "x", "o" }, "<D-b>", function()
  if pcall(require, "nvim-tree") then
    vim.cmd("NvimTreeToggle")
  elseif pcall(require, "neotree") then
    vim.cmd("Neotree toggle")
  else
    print("No file tree plugin available")
  end
end, { desc = "Toggle file tree" }) -- CMD-B for toggling file tree
vim.keymap.set({ "n", "v", "x", "o" }, "<D-p>", "<cmd>Telescope find_files<CR>") -- CMD-P for toggling file search

-- -- from 0 to 9
-- local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
-- local Snums = ")!@#$%^&*("
-- for i = 0, 9 do
--   local alphaK = alphabet:sub(i, i)
--   local Snum = Snums:sub(i, i)
--   -- Go to mark with M + [A-Z]
--   vim.keymap.set("n", "<M-" .. i .. ">", "`" .. alphaK)
--   -- Shift sets the mark
--   vim.keymap.set("n", "<M-S-" .. Snum .. ">", "m" .. alphaK)
-- end

local mappings = {
  n = {
    -- Movement
    ["n"] = { macro.better_search "n", desc = "Next search with center and unfold" },
    ["N"] = { macro.better_search "N", desc = "previous search with center and unfold" },
    -- ["<C-o>"] = { "<C-o>zz", desc = "Recenter" },
    ["]w"] = { "<C-w>l", desc = "Move to right split" },
    ["[w"] = { "<C-w>h", desc = "Move to left split" },
    -- ["M-{"] = {
    --   function()
    --     local ts_utils = require "nvim-treesitter.ts_utils"
    --     local node = ts_utils.get_node_at_cursor()
    --     local parent = node:parent()
    --     if parent then
    --       -- use goto_node
    --       ts_utils.goto_node(parent, false, true)
    --     end
    --   end,
    --   noremap = true,
    --   desc = "Go to parent noode",
    -- },
    -- ["M-}"] = {
    --   noremap = true,
    --   desc = "Go to child node",
    --   function()
    --     local ts_utils = require "nvim-treesitter.ts_utils"
    --     local node = ts_utils.get_node_at_cursor()
    --     if node then
    --       -- use goto_node
    --       ts_utils.goto_node(node, true, true)
    --     end
    --   end,
    -- },
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    ["<S-Tab>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Next buffer",
    },
    ["<C-c>"] = { "ggVGy" }, -- C-c to yank whole file
    -- ["<M-a>"] = { "ggVG" }, -- Select everything
    ["<leader>x"] = {
      -- Close current buffer
      function() require("astronvim.utils.buffer").close(vim.fn.bufnr "%") end,
      desc = "Close current buffer",
    },
    ["<leader>tcd"] = {
      function()
        local buffer = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buffer)
        local cwd = vim.fn.fnamemodify(bufname, ":h")
        vim.api.nvim_command("tcd " .. cwd)
      end,
      desc = "Change tab's CWD to current buffer's directory",
    },
    ["<Tab>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["?"] = { "?\\v", desc = "search backwards with very magic" },
    ["<leader>gx"] = {
      function()
        -- Open current file in browser
        local path = vim.fn.expand "%:p"
        local url = "file://" .. path
        vim.fn.jobstart { "open", url }
      end,
      desc = "Open file in browser",
    },
    ["<leader>dc"] = false,
    ["<leader>lx"] = {
      "<cmd>ClangdSwitchSourceHeader<CR>",
      desc = "Switch between C++ source and header",
    },
    -- The above gd-zz doesn't work, we maybe need to split it in two commands
    -- Select previously pasted
    ["gV"] = { "`[v`]", desc = "Select previously pasted" },
    ["U"] = { "<cmd>redo<CR>", desc = "Redo" },

    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },

    -- Commands
    ["<leader>w"] = { desc = "Win cmds" },
    ["<leader>wd"] = {
      (function()
        local bit = false
        return function()
          if bit then
            vim.cmd "windo diffoff"
          else
            vim.cmd "windo diffthis"
          end
          bit = not bit
        end
      end)(),
      desc = "Toggle diff on open splits",
    },
    ["<M-F>"] = {
      function()
        vim.fn.setreg("+", "")
        print "Clipboard register reset"
      end,
      desc = "Reset clipboard register",
    },
    ["<M-f>"] = {
      function()
        local filepath = vim.fn.expand "%:p"
        local current_clipboard = vim.fn.getreg "+"
        vim.fn.setreg("+", filepath)
        print("Copied file path to clipboard: " .. filepath)
      end,
      desc = "Copy current buffer file path to clipboard",
    },
    -- Add a fallback formatting keymap that checks for LSP formatting first
    ["<leader>lf"] = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      
      -- Check if any attached client supports formatting
      local can_format = false
      for _, client in pairs(clients) do
        if client.supports_method("textDocument/formatting") then
          can_format = true
          break
        end
      end

      if can_format then
        vim.lsp.buf.format(require("astronvim.utils.lsp").format_opts)
      else
        vim.notify("No LSP formatter available for this buffer", vim.log.levels.WARN)
      end
    end,
    desc = "Format buffer",
  },

  v = {
    ["r"] = { [[0y<Esc>:s/\V<C-R>=escape(@", '/\')<CR>/&/gc<Left><Left><Left>]] },
    -- ["R"] = { [[y:%s/\V<C-R>0/&/gc<Left><Left><Left>]] },
    ["R"] = { [["0y<Esc>:%s/\V<C-R>=escape(@0, '/\')<CR>/&/gc<Left><Left><Left>]] },
    ["?"] = { "/\\%V" },
  },

  -- i = {
  --   ["<M-O>"] = { "<C-o>O" },
  --   -- ["<M-l>"] = { "<cmd>><cr>", desc = "indent" },
  --   -- ["<M-h>"] = { "<cmd><<cr>", desc = "indent" },
  -- },
}

local mapping_files = vim.fn.glob(vim.fn.stdpath "config" .. "/lua/user/keymaps/*.lua", false, true)
local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        deep_merge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

for _, file in ipairs(mapping_files) do
  local map_table = dofile(file)
  mappings = deep_merge(mappings, map_table)
end
-- Add command mappings for :Q and :Qa
vim.cmd [[command! Q q]]
vim.cmd [[command! Qa qa]]

return mappings
