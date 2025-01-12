return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  enabled = false,
  lazy = true,
  cmd = {
    "NvimTreeOpen",
    "NvimTreeClose", 
    "NvimTreeToggle",
    "NvimTreeFocus",
    "NvimTreeRefresh",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeClipboard",
    "NvimTreeResize",
    "NvimTreeCollapse",
    "NvimTreeCollapseKeepBuffers",
    "NvimTreeHiTest"
  },
  config = function()
    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Create global variable to store bookmarks
    -- if not vim.g.nvim_tree_bookmarks then
    --   vim.g.nvim_tree_bookmarks = {}
    -- end

    -- Function to save bookmarks
    -- local function save_bookmarks()
    --   local api = require("nvim-tree.api")
    --   local marks = api.marks.list()
    --   local bookmark_paths = {}
    --   for _, node in pairs(marks) do
    --     table.insert(bookmark_paths, node.absolute_path)
    --   end
    --   vim.g.nvim_tree_bookmarks = bookmark_paths
    -- end

    -- Function to restore bookmarks
    -- local function restore_bookmarks()
    --   local api = require("nvim-tree.api")
    --   if vim.g.nvim_tree_bookmarks then
    --     for _, path in ipairs(vim.g.nvim_tree_bookmarks) do
    --       -- Find the node by path and mark it
    --       api.tree.find_file({ buf = path, focus = false })
    --       local node = api.tree.get_node_under_cursor()
    --       if node then
    --         api.marks.toggle(node)
    --       end
    --     end
    --   end
    -- end

    -- Subscribe to events for saving bookmarks
    local api = require("nvim-tree.api")
    -- api.events.subscribe(api.events.Event.TreeClose, save_bookmarks)

    -- Original on_attach function
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- Remove default mappings we want to override
      vim.keymap.del('n', '<C-]>', { buffer = bufnr })
      vim.keymap.del('n', '.', { buffer = bufnr })
      vim.keymap.del('n', '<BS>', { buffer = bufnr })

      -- Add our custom mappings
      vim.keymap.set('n', '.', api.tree.change_root_to_node, opts("CD"))
      vim.keymap.set('n', '<C-]>', api.node.run.cmd, opts("Run Command"))
      vim.keymap.set('n', '<BS>', api.tree.change_root_to_parent, opts("Up"))

      -- Keep the other custom mappings
      vim.keymap.set('n', 'l', api.node.open.edit, opts("Open"))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts("Close Directory"))
      vim.keymap.set('n', 'o', api.node.open.edit, opts("Open"))
      vim.keymap.set('n', 'O', api.node.run.system, opts("System Open"))
      vim.keymap.set('n', 'F', function()
        local node = api.tree.get_node_under_cursor()
        local path = node.absolute_path
        local is_folder = node.type == "directory"
        require("telescope.builtin").find_files({
          cwd = is_folder and path or vim.fn.fnamemodify(path, ":h")
        })
      end, opts("Find in Directory"))
    end

    -- Subscribe to TreeOpen event to restore bookmarks
    -- api.events.subscribe(api.events.Event.TreeOpen, restore_bookmarks)

    -- Main nvim-tree setup
    require("nvim-tree").setup({
      on_attach = my_on_attach,
      respect_buf_cwd = false,
      sync_root_with_cwd = false,
      reload_on_bufenter = true,
      view = {
        width = {
          min = 35,
          max = 35,
          padding = 1,
        },
        side = "left",
        preserve_window_proportions = true,
      },
      renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = false,
        -- highlight_opened_files = false,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          web_devicons = {
            file = {
              enable = true,
            },
            folder = {
              enable = true,
            },
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {
          ".DS_Store",
          ".venv",
          ".git",
          ".mypy_cache",
          ".pdbignore",
          ".plandex",
          ".copilot.log",
          "__pycache__",
          "node_modules",
          ".null-ls*",
          ".aider*",
          ".worktree*",
        },
      },
      git = {
        enable = false,
        timeout = 400,
      },
      diagnostics = {
        enable = false,
      },
      modified = {
        enable = false,
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = true,
          restrict_above_cwd = false,
        },
        open_file = {
          resize_window = false,
          quit_on_open = false,
          window_picker = {
            enable = true,
          },
        },
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
      },
      notify = {
        threshold = vim.log.levels.ERROR,
      },
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
    })

    -- Global keymaps
    vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
    vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>', { silent = true })
  end,
} 
