-- TODO: replace <leader> to <Leader> everywhere in AstroNvim v4 to match vimdoc
local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local ui = require "astronvim.utils.ui"

local maps = utils.empty_map_table()

local sections = {
  f = { desc = get_icon("Search", 1, true) .. "Find" },
  p = { desc = get_icon("Package", 1, true) .. "Packages" },
  l = { desc = get_icon("ActiveLSP", 1, true) .. "LSP" },
  u = { desc = get_icon("Window", 1, true) .. "UI/UX" },
  b = { desc = get_icon("Tab", 1, true) .. "Buffers" },
  bs = { desc = get_icon("Sort", 1, true) .. "Sort Buffers" },
  -- d = { desc = get_icon("Debugger", 1, true) .. "Debugger" }, # defined in plugins.dap.lua
  g = { desc = get_icon("Git", 1, true) .. "Git" },
  S = { desc = get_icon("Session", 1, true) .. "Session" },
  t = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
  q = { desc = get_icon("Terminal", 1, true) .. "Quick fix" },
}

-- Normal --
-- Standard Operations
maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["<D-s>"] = maps.n["<C-s>"]
maps.i["<C-s>"] = maps.n["<C-s>"]
maps.i["<D-s>"] = maps.n["<C-s>"]
maps.n["<C-q><C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit", noremap = true }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }
-- TODO: Remove when dropping support for <Neovim v0.10
if not vim.ui.open then maps.n["gx"] = { utils.system_open, desc = "Open the file under cursor with system app" } end

-- Manage Buffers
maps.n["]b"] =
  { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" }
maps.n["[b"] = {
  function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}
maps.n[">b"] = {
  function() require("astronvim.utils.buffer").move(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Move buffer tab right",
}
maps.n["<b"] = {
  function() require("astronvim.utils.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Move buffer tab left",
}

maps.n["<leader>bc"] =
  { function() require("astronvim.utils.buffer").close_all(true) end, desc = "Close all buffers except current" }
maps.n["<leader>bC"] = { function() require("astronvim.utils.buffer").close_all() end, desc = "Close all buffers" }
maps.n["<leader>bl"] =
  { function() require("astronvim.utils.buffer").close_left() end, desc = "Close all buffers to the left" }
maps.n["<leader>bp"] = { function() require("astronvim.utils.buffer").prev() end, desc = "Previous buffer" }
maps.n["<leader>br"] =
  { function() require("astronvim.utils.buffer").close_right() end, desc = "Close all buffers to the right" }
maps.n["<leader>bs"] = sections.bs
maps.n["<leader>bse"] = { function() require("astronvim.utils.buffer").sort "extension" end, desc = "By extension" }
maps.n["<leader>bsr"] =
  { function() require("astronvim.utils.buffer").sort "unique_path" end, desc = "By relative path" }
maps.n["<leader>bsp"] = { function() require("astronvim.utils.buffer").sort "full_path" end, desc = "By full path" }
maps.n["<leader>bsi"] = { function() require("astronvim.utils.buffer").sort "bufnr" end, desc = "By buffer number" }
maps.n["<leader>bsm"] = { function() require("astronvim.utils.buffer").sort "modified" end, desc = "By modification" }

if is_available "heirline.nvim" then
  maps.n["<leader>bd"] = {
    function()
      require("astronvim.utils.status.heirline").buffer_picker(
        function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
      )
    end,
    desc = "Close buffer from tabline",
  }
  maps.n["<leader>b\\"] = {
    function()
      require("astronvim.utils.status.heirline").buffer_picker(function(bufnr)
        vim.cmd.split()
        vim.api.nvim_win_set_buf(0, bufnr)
      end)
    end,
    desc = "Horizontal split buffer from tabline",
  }
  maps.n["<leader>b|"] = {
    function()
      require("astronvim.utils.status.heirline").buffer_picker(function(bufnr)
        vim.cmd.vsplit()
        vim.api.nvim_win_set_buf(0, bufnr)
      end)
    end,
    desc = "Vertical split buffer from tabline",
  }
end

-- Navigate tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

-- Comment
if is_available "Comment.nvim" then
  maps.n["<leader>/"] = {
    function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
    desc = "Toggle comment line",
  }
  maps.v["<leader>/"] = {
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    desc = "Toggle comment for selection",
  }

  -- TODO: DUPLICATE: REMOVE SOON
  maps.n["<leader>k"] = {
    function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
    desc = "Toggle comment line",
  }
  maps.v["<leader>k"] = {
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    desc = "Toggle comment for selection",
  }
end

-- GitSigns
if is_available "gitsigns.nvim" then
  maps.n["<leader>g"] = sections.g
  maps.n["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
  maps.n["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }
  maps.n["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }
  maps.n["<leader>gL"] = { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" }
  maps.n["<leader>gp"] = { function() require("gitsigns").preview_hunk() end, desc = "Preview Git hunk" }
  maps.n["<leader>gh"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" }
  maps.n["<leader>gr"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" }
  maps.n["<leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" }
  maps.n["<leader>gS"] = { function() require("gitsigns").stage_buffer() end, desc = "Stage Git buffer" }
  maps.n["<leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" }
  maps.n["<leader>gd"] = { function() require("gitsigns").diffthis() end, desc = "View Git diff" }
end

maps.n["<M-b>"] = { "^", desc = "Start of line" }
maps.n["<M-e>"] = { "$", desc = "End of line" }

if is_available "nvim-tree.lua" then
  maps.n["<M-E>"] = { "<cmd>NvimTreeToggle<CR>", desc = "Toggle Explorer" }
  maps.n["<leader>e"] = maps.n["<M-E>"]
  maps.n["<leader>o"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd "NvimTreeFocus"
      end
    end,
    desc = "Toggle Explorer Focus",
  }
elseif is_available "neo-tree.nvim" then
  maps.n["<M-E>"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
  -- maps.n["<M-E>"] = {
  --   function()
  --     if vim.bo.filetype == "neo-tree" then
  --       vim.cmd.wincmd "p"
  --     else
  --       vim.cmd.Neotree "focus"
  --     end
  --   end,
  --   desc = "Toggle Explorer Focus",
  -- }
  -- -- backward compatibility with <leader>e and <leader>o
  maps.n["<leader>e"] = maps.n["<M-E>"]
  maps.n["<leader>o"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd.Neotree "focus"
      end
    end,
    desc = "Toggle Explorer Focus",
  }
end

if is_available "resession.nvim" then
  maps.n["<leader>S"] = sections.S
  maps.n["<leader>Sl"] = { function() require("resession").load "Last Session" end, desc = "Load last session" }
  maps.n["<leader>Ss"] = { function() require("resession").save() end, desc = "Save this session" }
  maps.n["<leader>St"] = { function() require("resession").save_tab() end, desc = "Save this tab's session" }
  maps.n["<leader>Sd"] = { function() require("resession").delete() end, desc = "Delete a session" }
  maps.n["<leader>Sf"] = { function() require("resession").load() end, desc = "Load a session" }
  maps.n["<leader>S."] = {
    function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
    desc = "Load current directory session",
  }

  maps.n["<F11>"] = maps.n["<leader>S."]
end

-- Smart Splits
if is_available "smart-splits.nvim" then
  maps.n["<M-]>"] = { "<cmd>tabnext<CR>", desc = "Move to left split" }
  maps.n["<M-[>"] = { "<cmd>tabprevious<CR>", desc = "Move to left split" }
  -- maps.n["<M-{>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" }
  -- maps.n["<M-}>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }
  maps.n["<M-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" }
  maps.n["<M-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" }
  maps.n["<M-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" }
  maps.n["<M-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }
  maps.n["<C-Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
  maps.n["<C-Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
  maps.n["<C-Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
  maps.n["<C-Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
else
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<C-Up>"] = { "<cmd>resize -4<CR>", desc = "Resize split up" }
  maps.n["<C-Down>"] = { "<cmd>resize +4<CR>", desc = "Resize split down" }
  maps.n["<C-Left>"] = { "<cmd>vertical resize -4<CR>", desc = "Resize split left" }
  maps.n["<C-Right>"] = { "<cmd>vertical resize +4<CR>", desc = "Resize split right" }
end

-- SymbolsOutline
if is_available "aerial.nvim" then
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" }
end

-- Telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f"] = sections.f
  maps.n["<leader>g"] = sections.g
  maps.n["<leader>gb"] =
    { function() require("telescope.builtin").git_branches { use_file_path = true } end, desc = "Git branches" }
  maps.n["<leader>gc"] = {
    function() require("telescope.builtin").git_bcommits() end,
    desc = "Git commits (buffer)",
    noremap = true,
  }
  maps.n["<leader>gC"] = {
    function()
      local opts = {
        -- current_file = vim.fn.expand "%:p",
        git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit" },
      }
      local current_line = vim.fn.line "."
      table.insert(opts.git_command, "-L")
      table.insert(opts.git_command, current_line .. "," .. current_line .. ":" .. opts.current_file)
      require("telescope.builtin").git_commits(opts)
    end,
    desc = "Git commits (current line or selection)",
  }

  -- if mode == "v" or mode == "V" or mode == "\22" then
  --   local start_pos = vim.fn.getpos("'<")
  --   local end_pos = vim.fn.getpos("'>")
  --   local start_line = start_pos[2]
  --   local end_line = end_pos[2]
  --   opts.git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "-L", start_line .. "," .. end_line .. ":" .. opts.current_file }
  -- else
  maps.n["<leader>gt"] =
    { function() require("telescope.builtin").git_status { use_file_path = true } end, desc = "Git status" }
  maps.n["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<M-CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<leader>fm"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>f/"] =
    { function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Find words in current buffer" }
  maps.n["<leader>fa"] = {
    -- function()
    --   local cwd = vim.fn.stdpath "config" .. "/.."
    --   local search_dirs = {}
    --   for _, dir in ipairs(astronvim.supported_configs) do -- search all supported config locations
    --     if dir == astronvim.install.home then dir = dir .. "/lua/user" end -- don't search the astronvim core files
    --     if vim.fn.isdirectory(dir) == 1 then table.insert(search_dirs, dir) end -- add directory to search if exists
    --   end
    --   if vim.tbl_isempty(search_dirs) then -- if no config folders found, show warning
    --     utils.notify("No user configuration files found", vim.log.levels.WARN)
    --   else
    --     if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
    --     require("telescope.builtin").find_files {
    --       prompt_title = "Config Files",
    --       search_dirs = search_dirs,
    --       cwd = cwd,
    --       follow = true,
    --     } -- call telescope
    --   end
    -- end,
    ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    desc = "Live grep args",
  }
  -- maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
  maps.n["<leader>fc"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" }
  maps.n["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
  maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" }
  maps.n["<leader>fg"] = { function() require("telescope.builtin").git_files() end, desc = "Find [GIT] files" }

  -- maps.n["<leader>fg"] =
  --   { function() require("user.util.telescope.actions").project_files() end, desc = "" }
  maps.n["<leader>fF"] = {
    function()
      require("telescope.builtin").find_files {
        hidden = true,
        -- no_ignore = true,
        -- no_ignore_parent = true,
        no_signs = true,
      }
    end,
    desc = "Find files",
  }

  -- Forward the mapping to just "ff"
  maps.n["ff"] = maps.n["<leader>ff"]

  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
  maps.n["<leader>fn"] = { 
    function() require("snacks").notifier.show_history() end, 
    desc = "Show Notification History" 
  }
  maps.n["<leader>fO"] =
    { function() require("user.util.telescope.pickers").old_files_sorted() end, desc = "Find old files" }
  maps.n["<leader>fo"] = {
    function()
      require("user.util.telescope.pickers").old_files_sorted {
        cwd_only = true,
      }
    end,
    desc = "Find old files (cwd)",
  }
  maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
  maps.n["<leader>fT"] =
    { function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc = "Find themes" }
  maps.n["<leader>ft"] = { "<cmd>TodoTelescope<CR>", desc = "Find todo" }
  maps.n["<leader>fS"] = { "<cmd>Telescope treesitter<CR>", desc = "Find treesitter symbols" }
  maps.n["<leader>fs"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find LSP symbols" }
  -- Live grep within import lines jk
  -- maps.n["<leader>fi
  maps.n["<leader>fw"] = {
    function() require("telescope.builtin").live_grep { use_regex = false } end,
    desc = "Find words",
  }
  maps.n["<leader>fW"] = {
    function()
      require("telescope.builtin").live_grep {
        use_regex = true,
        additional_args = function(args) return vim.list_extend(args, { "--hidden" }) end,
      }
    end,
    desc = "Find words (regex)",
  }
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>ls"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbols",
  }
  maps.n["<leader>fJ"] = {
    function()
      require("telescope.builtin").jumplist {
        show_line = true,
        -- use vertical layout
        fname_width = 100,
      }
    end,
    desc = "Jumplist",
  }
  maps.n["<leader>fj"] = {
    function()
      require("telescope.builtin").jumplist {
        show_line = false,
        trim_text = true,
      }
    end,
    desc = "Jumplist",
  }
  maps.n["<leader>fB"] = {
    -- Find words in all open buffers
    function() require("telescope.builtin").live_grep { grep_open_files = true } end,
    desc = "Find words in all open buffers",
  }
  maps.n["<leader>fd"] = {
    -- Browse current file directory
    function()
      local cur_buffer_cwd = vim.fn.expand "%:p:h"
      require("telescope").extensions.file_browser.file_browser {
        -- browse folders
        auto_depth = true,
      }
    end,
    desc = "File explorer",
  }
  maps.n["<leader>fD"] = {
    -- Browse current file directory
    function()
      local cur_buffer_cwd = vim.fn.expand "%:p:h"
      require("telescope").extensions.file_browser.file_browser {
        cwd = cur_buffer_cwd,
        auto_depth = true,
      }
    end,
    desc = "File explorer",
  }
  maps.n["<leader>fe"] = {
    -- Runs file_browser picker
    function()
      require("telescope").extensions.file_browser.file_browser {
        auto_depth = 3,
      }
    end,
    desc = "File explorer",
  }
end

-- Terminal
if is_available "toggleterm.nvim" then
  maps.n["<leader>t"] = sections.t
  if vim.fn.executable "lazygit" == 1 then
    maps.n["<leader>g"] = sections.g
    maps.n["<leader>gg"] = {
      function()
        local worktree = require("astronvim.utils.git").file_worktree()
        local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
        utils.toggle_term_cmd {
          cmd = "lazygit" .. flags,
          direction = "tab",
        }
      end,
      desc = "ToggleTerm lazygit",
    }
    maps.n["<leader>tl"] = maps.n["<leader>gg"]
  end
end

-- Improved Code Folding
if is_available "nvim-ufo" then
  maps.n["zR"] = { function() require("ufo").openAllFolds() end, desc = "Open all folds" }
  maps.n["zM"] = { function() require("ufo").closeAllFolds() end, desc = "Close all folds" }
  maps.n["zr"] = { function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" }
  maps.n["zm"] = { function() require("ufo").closeFoldsWith() end, desc = "Fold more" }
  maps.n["zp"] = { function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" }
end

-- Stay in indent mode
maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

-- Improved Terminal Navigation
-- maps.t["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
-- maps.t["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
-- maps.t["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
-- maps.t["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

maps.n["<leader>u"] = sections.u
-- Custom menu for modification of the user experience
if is_available "nvim-autopairs" then maps.n["<leader>ua"] = { ui.toggle_autopairs, desc = "Toggle autopairs" } end
maps.n["<leader>ub"] = { ui.toggle_background, desc = "Toggle background" }
if is_available "nvim-cmp" then maps.n["<leader>uc"] = { ui.toggle_cmp, desc = "Toggle autocompletion" } end
if is_available "nvim-colorizer.lua" then
  maps.n["<leader>uC"] = { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlight" }
end
maps.n["<leader>ud"] = { ui.toggle_diagnostics, desc = "Toggle diagnostics" }
maps.n["<F12>"] = maps.n["<leader>ud"]
maps.n["<leader>ug"] = { ui.toggle_signcolumn, desc = "Toggle signcolumn" }
maps.n["<leader>ui"] = { ui.set_indent, desc = "Change indent setting" }
maps.n["<leader>ul"] = { ui.toggle_statusline, desc = "Toggle statusline" }
maps.n["<leader>uL"] = { ui.toggle_codelens, desc = "Toggle CodeLens" }
maps.n["<leader>un"] = { ui.change_number, desc = "Change line numbering" }
maps.n["<leader>uN"] = { ui.toggle_ui_notifications, desc = "Toggle Notifications" }
maps.n["<leader>up"] = { ui.toggle_paste, desc = "Toggle paste mode" }
maps.n["<leader>us"] = { ui.toggle_spell, desc = "Toggle spellcheck" }
maps.n["<leader>uS"] = { ui.toggle_conceal, desc = "Toggle conceal" }
maps.n["<leader>ut"] = { ui.toggle_tabline, desc = "Toggle tabline" }
maps.n["<leader>uu"] = { ui.toggle_url_match, desc = "Toggle URL highlight" }
maps.n["<leader>uw"] = { ui.toggle_wrap, desc = "Toggle wrap" }
maps.n["<leader>uy"] = { ui.toggle_syntax, desc = "Toggle syntax highlighting (buffer)" }
maps.n["<leader>uh"] = { ui.toggle_foldcolumn, desc = "Toggle foldcolumn" }

-- Add these to your mapping configuration
maps.n["<leader>s"] = { desc = "󰻾 Symbol Navigation" }
-- Enhanced symbol navigation
maps.n["<leader>ss"] = { function() require("aerial").toggle() end, desc = "Symbol Outline (Toggle)" }
maps.n["<leader>sn"] = { function() require("aerial").nav_toggle() end, desc = "Symbol Navigator (Current File)" }
-- Aerial + Telescope integration for workspace symbols
maps.n["<leader>sS"] = { function() 
  require("telescope").extensions.aerial.aerial({
    layout_config = {
      width = 0.95,
      height = 0.8,
      preview_width = 0.5,
    },
    show_nesting = {
      ["_"] = true,    -- Nesting shown for all file types
      json = true,     -- Enable for specific file types
      yaml = true,
    },
  })
end, desc = "Browse All Symbols (Workspace)" }
-- Quick symbol finder
maps.n["<leader>sf"] = { function()
  local aerial_avail, aerial = pcall(require, "aerial")
  if aerial_avail then
    aerial.aerial_telescope({
      attach_mode = "global",
      show_nesting = true,
      layout_config = { preview_width = 0.55 },
    })
  end
end, desc = "Find Symbol (Telescope)" }
-- Dynamic symbol search
maps.n["<leader>sd"] = { function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols({
    show_line = true,
    fname_width = 30,
    symbol_width = 50,
    path_display = { "tail" },
    symbol_type_width = 12,
    layout_config = {
      preview_width = 0.55,
    },
    layout_strategy = "horizontal",
  })
end, desc = "Search Symbols (Dynamic)" }

utils.set_mappings(astronvim.user_opts("mappings", maps))
