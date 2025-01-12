return function(_, opts)
  local telescope = require "telescope"
  telescope.setup(opts)
  
  local utils = require "astronvim.utils"
  local conditional_func = utils.conditional_func
  conditional_func(telescope.load_extension, pcall "workspaces.nvim", "workspaces")
  conditional_func(telescope.load_extension, pcall "telescope-live-grep-args.nvim", "live_grep_args")
  conditional_func(telescope.load_extension, pcall "telescope-undo.nvim", "undo")
  conditional_func(telescope.load_extension, pcall "notify", "notify")
  conditional_func(telescope.load_extension, pcall "aerial.nvim", "aerial")
  conditional_func(telescope.load_extension, pcall "yankbank-nvim", "yankbank")
  conditional_func(telescope.load_extension, pcall "telescope-toggleterm", "toggleterm")
  conditional_func(telescope.load_extension, pcall "telescope-frecency.nvim", "frecency")
  conditional_func(telescope.load_extension, pcall "telescope-project.nvim", "project")
  conditional_func(telescope.load_extension, pcall "telescope-file-browser.nvim", "file_browser")

  -- Load fzf if available
  if utils.is_available "telescope-fzf-native.nvim" then
    telescope.load_extension "fzf"
  end
end
