vim.opt.viewoptions:remove "curdir" -- disable saving current directory with views
vim.opt.shortmess:append { s = true, I = true, A = true } -- disable search count wrap and startup messages
vim.opt.backspace:append { "nostop", "eol" } -- don't stop backspace at insert
vim.opt.diffopt:append "linematch:60" -- enable linematch diff algorithm

local options = astronvim.user_opts("options", {
  opt = {
    breakindent = true, -- wrap indent to match  line start
    clipboard = "unnamedplus", -- connection to the system clipboard
    cmdheight = not vim.g.vscode and 0 or 4, -- hide command line unless needed
    conceallevel = 0,
    completeopt = {  "menuone", "noselect", "noinsert", "popup" }, -- Options for insert mode completion
    -- completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion
    copyindent = true, -- copy the previous indentation on autoindenting
    cursorline = true, -- highlight the text line of the cursor
    expandtab = true, -- enable the use of space in tab
    fileencoding = "utf-8", -- file content encoding for the buffer
    fillchars = { eob = " " }, -- disable `~` on nonexistent lines
    foldenable = true, -- enable fold for nvim-ufo
    foldlevel = 99, -- set high foldlevel for nvim-ufo, otherwise it will fold on startup
    foldlevelstart = 99, -- start with all code unfolded
    -- foldcolumn = "1", -- vimrc
    history = 500, -- number of commands to remember in a history table
    ignorecase = true, -- case insensitive searching
    infercase = true, -- infer cases in keyword completion
    laststatus = 3, -- global statusline
    linebreak = true, -- wrap lines at 'breakat'
    mouse = "a", -- enable mouse support
    number = true, -- show numberline
    preserveindent = true, -- preserve indent structure as much as possible
    pumheight = 10, -- height of the pop up menu
    relativenumber = true, -- show relative numberline
    shiftwidth = 2, -- number of space inserted for indentation
    showmode = false, -- disable showing modes in command line
    showtabline = 2, -- always display tabline
    signcolumn = "auto:2", -- always show the sign column
    smartcase = true, -- case sensitive searching
    splitbelow = true, -- splitting a new window below the current one
    splitright = true, -- splitting a new window at the right of the current one
    tabstop = 2, -- number of space in a tab
    termguicolors = true, -- enable 24-bit RGB color in the TUI
    timeoutlen = 185, -- shorten key timeout length a little bit for which-key
    title = true, -- set terminal title to the filename and path
    undofile = true, -- enable persistent undo
    updatetime = 200, -- length of time to wait before triggering the plugin
    virtualedit = "block", -- allow going past end of line in visual block mode
    wrap = false, -- disable wrapping of lines longer than the width of window
    writebackup = false, -- disable making a backup before overwriting a file

    numberwidth = 4,
    splitkeep = "cursor",
    showcmdloc = "statusline",
    -- virtualedit = 'normal',
    lazyredraw = true,
    -- statusline = "%#Normal# ",
    scrolloff = 8,
    sidescrolloff = 5,
    shada = "!,'1000,<50,s10,h",
    winblend = 2,
    pumblend = 5,
    redrawtime = 500 , -- Time in milliseconds for redrawing the display.
    -- wildignorecase = true,
    wildoptions = "fuzzy,pum",
    synmaxcol = 170,
  },
  g = {
    mapleader = " ", -- set leader key
    maplocalleader = ",", -- set default local leader key
    -- AstroNvim specific global options
    max_file = { size = 1024 * 1024, lines = 5000 }, -- set global limits for large files
    viminfo = "'1000,<50,s20,h",
    signcolumn = "auto",
    statusline = "%#Normal# %C",
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    autoformat_enabled = false, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled = true, -- enable autopairs at start
    cmp_enabled = true, -- enable completion at start
    codelens_enabled = false, -- enable or disable automatic codelens refreshing for lsp that support it
    diagnostics_mode = 2, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    highlighturl_enabled = false, -- highlight URLs by default
    inlay_hints_enabled = false, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
    lsp_handlers_enabled = true, -- enable or disable default vim.lsp.handlers (hover and signature help)
    semantic_tokens_enabled = false, -- enable or disable LSP semantic tokens on startup
    ui_notifications_enabled = true, -- disable notifications (TODO: rename to  notifications_enabled in AstroNvim v4)
    resession_enabled = true,
    git_worktrees = nil, -- enable git integration for detached worktrees (specify a table where each entry is of the form { toplevel = vim.env.HOME, gitdir=vim.env.HOME .. "/.dotfiles" })
  },
  t = vim.t.bufs and vim.t.bufs or { bufs = vim.api.nvim_list_bufs() }, -- initialize buffers for the current tab
})

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
