local augroup = vim.api.nvim_create_augroup

-- Make qf windows open to the right
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "Trouble" },
  callback = function()
    vim.api.nvim_command "wincmd L"
    vim.api.nvim_command "vert resize 90"
  end,
})

-- :set formatoptions-=cro on buffers
-- Disabling automatic comment wrapping and insertion in certain situations.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function() vim.api.nvim_command "set formatoptions-=cro" end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})


-- Fix conceallevel for json, man, files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5", "help" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Fix highlight groups that might turn black
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Buffer text highlight groups
    vim.api.nvim_set_hl(0, "Normal", { fg = "fg", bg = "bg" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "fg", bg = "bg" })
    vim.api.nvim_set_hl(0, "NormalNC", { fg = "fg", bg = "bg" })
    
    -- Ensure line number column is visible
    vim.api.nvim_set_hl(0, "LineNr", { fg = "fg", bg = "bg" })
    vim.api.nvim_set_hl(0, "SignColumn", { fg = "fg", bg = "bg" })
  end,
  group = vim.api.nvim_create_augroup("FixHighlights", { clear = true }),
})

-- local unsupported_ftypes = {
--   "help",
--   "dashboard",
--   "NvimTree",
--   "packer",
--   "Trouble",
--   "fugitive",
--   "fugitiveblame",
--   "gitcommit",
--   "gitrebase",
--   "qf",
--   "log",
--   "git",
--   "TelescopePrompt",
--   "TelescopeResults",
--   "Trouble",
--   "lspinfo",
--   "lspsagafinder",
-- }

-- Disable line numbering for bufferes that aren't focused
-- vim.api.nvim_create_autocmd("WinEnter", {
--   pattern = { "*" },
--   callback = function()
--     if not vim.tbl_contains(unsupported_ftypes, vim.bo.filetype) then
--       vim.wo.number = true
--       vim.wo.relativenumber = true
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("WinLeave", {
--   pattern = { "*" },
--   callback = function()
--     if not vim.tbl_contains(unsupported_ftypes, vim.bo.filetype) then
--       vim.o.number = false
--       vim.o.relativenumber = false
--     end
--   end,
-- })
