return {
  "nvim-neo-tree/neo-tree.nvim",
  -- "pysan3/neo-tree.nvim",
  -- external repo
  -- enabled = false,
  -- dev = true,
  -- branch =  "fix-cursor-jumping",
  -- branch = "main", -- HACK: force neo-tree to checkout `main` for initial v3 migration since default branch has changed
  -- tag = "3.14",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "Neotree",
  init = function() vim.g.neo_tree_remove_legacy_commands = true end,
  opts = function()
    local utils = require "astronvim.utils"
    local get_icon = utils.get_icon
    return {
      -- USER
      respect_buf_cwd = true,
      auto_close = true,
      -- reveal_force_cwd = true,
      sync_root_with_cwd = true,
      git_status_async = false,
      refresh_on_write = true,
      enable_git_status = false,
      enable_diagnostics = false,
      enable_opened_markers = false,
      -- hide_root_node = false, -- Hide the root node.
      hide_dotfiles = false,
      log_level = "error",
      -- END USER
      -- auto_clean_after_session_restore = true,
      -- candidates
      enable_modified_markers = true,
      -- end candidates
      close_if_last_window = true,
      sources = { "filesystem", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = get_icon("FolderClosed", 1, true) .. "File" },
          -- { source = "harpoon-buffers", display_name = get_icon("DefaultFile", 1, true) .. "Harp" },
          -- { source = "Marks", display_name = get_icon("FileModified", 1, true) .. "Bufs" },
          { source = "git_status", display_name = get_icon("Git", 1, true) .. "Git" },
          -- { source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
        },
      },
      default_component_configs = {
        file_size = { enabled = false },
        indent = { padding = 0 },
        last_modified = { enabled = false },
        type = {
          enabled = false, -- min width of window required to show this column
        },
        name = {
          trailing_slash = false,
          highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
          -- Take values in { false (no highlight), true (only loaded),
          -- "all" (both loaded and unloaded)}. For more information,
          -- see the `show_unloaded` config of the `buffers` source.
          use_git_status_colors = false,
          -- highlight = "NeoTreeFileName",
        },
        icon = {
          enabled = true,
          folder_closed = get_icon "FolderClosed",
          folder_open = get_icon "FolderOpen",
          folder_empty = get_icon "FolderEmpty",
          folder_empty_open = get_icon "FolderEmpty",
          default = get_icon "DefaultFile",
        },
        modified = { symbol = get_icon "FileModified", enabled = false },
        git_status = {
          enabled = true,
          symbols = {
            added = get_icon "GitAdd",
            deleted = get_icon "GitDelete",
            modified = get_icon "GitChange",
            renamed = get_icon "GitRenamed",
            untracked = get_icon "GitUntracked",
            ignored = get_icon "GitIgnored",
            unstaged = get_icon "GitUnstaged",
            staged = get_icon "GitStaged",
            conflict = get_icon "GitConflict",
          },
        },
      },
      commands = {
        system_open = function(state)
          -- TODO: just use vim.ui.open when dropping support for Neovim <0.10
          (vim.ui.open or require("astronvim.utils").system_open)(state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH"] = filepath,
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            utils.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              utils.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").find_files {
            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
          }
        end,
      },
      window = {
        width = 35,
        auto_expand_width = true,
        mappings = {
          ["<space>"] = false, -- disable space until we figure out which-key disabling
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          ["H"] = "prev_source",
          ["L"] = "next_source",
          F = utils.is_available "telescope.nvim" and "find_in_dir" or nil,
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
          o = "open",
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
        },
        -- fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        --   ["<C-j>"] = "move_cursor_down",
        --   ["<C-k>"] = "move_cursor_up",
        -- },
      },
      buffers = {
        group_empty_dirs = true,
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = function()
          -- TODO: Do it if the file system size is lower than XX
          return true
        end,
        check_gitignore_in_search = false,
        cwd_target = {
          sidebar = "tab",
          current = "window",
        },
        filtered_items = {
          show_hidden_count = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          -- hide_hidden = false,
          hide_by_pattern = {
            ".null-ls*",
            ".aider*",
            ".worktree*"
          },
          hide_by_name = {
            ".DS_Store",
            ".venv",
            ".git",
            ".mypy_cache",
            ".pdbignore", 
            ".plandex",
            ".copilot.log",
            "__pycache__",
            "node_modules",
          },
          visible = false,
        },
      },
      -- event_handlers = {
        -- { TODO: This was experimenta
        --      https://chatgpt.com/c/66e88fd1-9318-8011-a312-27064b3a4450
        --   event = "file_renamed",
        --   handler = function(args)
        --     -- args.source = the original path
        --     -- args.destination = the new path
        --     -- Prepare parameters for LSP command
        --     local params = {
        --       oldUri = vim.uri_from_fname(args.source),
        --       newUri = vim.uri_from_fname(args.destination),
        --     }
        --
        --     -- Trigger LSP to handle renaming (fixing imports, references, etc.)
        --     vim.lsp.buf.execute_command {
        --       command = "workspace/didRenameFiles",
        --       arguments = { params },
        --     }
        --   end,
        -- },
      -- },
    }
  end,
}
