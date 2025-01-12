local git_version = vim.fn.system { "git", "--version" }
if vim.api.nvim_get_vvar "shell_error" ~= 0 then
  vim.api.nvim_err_writeln("Git doesn't appear to be available...\n\n" .. git_version)
end
local major, min, _ = unpack(vim.tbl_map(tonumber, vim.split(git_version:match "%d+%.%d+%.%d", "%.")))
local modern_git = major > 2 or (major == 2 and min >= 19)

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

local user_plugins = astronvim.user_opts "plugins"
for _, config_dir in ipairs(astronvim.supported_configs) do
  if vim.fn.isdirectory(config_dir .. "/lua/user/plugins") == 1 then user_plugins = { import = "user.plugins" } end
end

local spec = astronvim.updater.options.pin_plugins and { { import = astronvim.updater.snapshot.module } } or {}
vim.list_extend(spec, { { import = "plugins" }, user_plugins })

local colorscheme = astronvim.default_colorscheme and { astronvim.default_colorscheme } or nil
local setup_args = astronvim.user_opts("lazy", {
  spec = spec,
  git = { filter = modern_git },
  install = { colorscheme = colorscheme },
  dev = {
    -- directory where you store your local plugin projects
    path = "~/",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {},    -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  performance = {
    rtp = {
      paths = astronvim.supported_configs,
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
      reset = false, -- need this because otherwise lazy.nvim reset the runtimepath
    },
  },
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
})

require("lazy").setup(setup_args)

-- if vscode_loaded then require "vscode-config.mappings" end
--
-- if vim.g.vscode then print "VSCode WAS enabled" end
-- Important: delete the nvim parser. See https://www.reddit.com/r/neovim/comments/z9008g/nvimtreesitter_invalid_node_type_at_position_5/
-- Verify no more than treesitter parser is running:
-- :echo nvim_get_runtime_file('parser', v:true)

-- local current_nvim_version = vim.version()
-- local ver_str = current_nvim_version.major .. "." .. current_nvim_version.minor .. "." .. current_nvim_version.patch
-- local ver_str = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
-- vim.opt.rtp:remove("/usr/local/Cellar/neovim/" .. ver_str .. "/lib/nvim") -- this is the important bit

-- vim.opt.rtp:remove("/usr/local/Cellar/neovim/0.10.0/lib/nvim")
