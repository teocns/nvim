return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  commit = "2eca9ba22002184ac05eddbe47a7fe2d5a384dfc",
  dependencies = {
    -- { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
    { "nvim-telescope/telescope-fzy-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },


  },
  cmd = "Telescope",
  lazy = true,
  opts = function()
    local actions = require "telescope.actions"
    local utils = require "telescope.utils"
    local action_state = require "telescope.actions.state"
    local get_icon = require("astronvim.utils").get_icon
    local layout = require "telescope.actions.layout"
    local function to_win_or_tab(prompt_bufnr)
      -- Sends the current selection to a new tab if there's many windows, else to the current window
      local num_wins = #vim.api.nvim_list_wins()
      if num_wins > 1 then
        -- If there is more than one tab, open the selected entry in a new tab
        actions.select_tab(prompt_bufnr)
      else
        -- If there is only one tab, open the selection in the current window
        actions.select_default(prompt_bufnr)
      end
    end

    -- Define ignore patterns once to use in multiple places
    local ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.svg",
      "%.png",
      "%.jpg",
      "%.jpeg",
      "%.lock",
      "%.DS_Store",
      "%.venv",
      "%.json",
    }

    return {
      extensions = {
        file_browser = {
          hijack_netrw = true,
          respects_gitignore = false,
          git_status = false,
          no_ignore = true,
          hidden = false,
          display_stat = false,
          initial_mode = "insert",
        },
        -- custom_sorter = function()
        --   local buffer_list = vim.fn.getbufinfo { buflisted = 1 }
        --   local buffer_paths = {}
        --   for _, buffer in ipairs(buffer_list) do
        --     buffer_paths[buffer.name] = true
        --   end
        --
        --   return function(a, b)
        --     local a_is_buffer = buffer_paths[a.path] and 100000 or 0
        --     local b_is_buffer = buffer_paths[b.path] and 100000 or 0
        --     if a_is_buffer ~= b_is_buffer then return a_is_buffer > b_is_buffer end
        --     return a.score > b.score
        --   end
        -- end,
        undo = {
          layout_strategy = "horizontal",
          mappings = {
            -- Wrapping the actions inside a function prevents the error due to telescope-undo being not
            -- yet loaded.
            i = {
              ["<cr>"] = false,
              ["<S-cr>"] = false,
              ["<C-cr>"] = false,

              -- alternative defaults, for users whose terminals do questionable things with modified <cr>
              ["<C-y>"] = require("telescope-undo.actions").yank_additions,
              ["<C-Y>"] = require("telescope-undo.actions").yank_deletions,
              ["<C-r>"] = require("telescope-undo.actions").restore,
            },
            n = {
              ["y"] = require("telescope-undo.actions").yank_additions,
              ["Y"] = require("telescope-undo.actions").yank_deletions,
              ["u"] = require("telescope-undo.actions").restore,
            },
          },
        },
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        -- frecency = {
        --   show_filter_column = false,
        --   initial_mode = "insert",
        --   show_unindexed = false,
        --   layout_strategy = "horizontal",
        --   auto_validate = false,
        --   workspaces = {
        --     ["fp"] = "~/.gchromium/fingerprinting/src/fingerprinting",
        --     ["nvim"] = "~/.config/nvim/lua",
        --     ["blr"] = "~/.gchromium/fingerprinting/src/third_party/blink/renderer/core/",
        --   },
        -- },
        project = {
          cd_scope = { "tab" },
          initial_mode = "insert",
          -- display_type = "minimnal",
          on_project_selected = function(prompt_bufnr)
            -- Createa a new tab:
            local project_actions = require "telescope._extensions.project.actions"

            local working_dir = project_actions.get_selected_path(prompt_bufnr)
            -- Change to the project's root directory
            vim.cmd("tcd " .. working_dir)

            -- close the telescope
            actions.close(prompt_bufnr)
          end,
        },
      },
      pickers = {
        lsp_definitions = {
          file_ignore_patterns = {}, -- Empty to allow venv files for LSP operations
        },
        lsp_references = {
          file_ignore_patterns = {}, -- Also allow venv files for references
        },
        lsp_implementations = {
          file_ignore_patterns = {}, -- And implementations
        },
        file_browser = {
          display_stat = false,
          git_status = false,
          respects_gitignore = false,
          select_buffer = true,
          prompt_path = true,
        },
        lsp_document_symbols = {
          symbol_width = 50,
          symbol_type_width = 12,
          initial_mode = "normal",
          previewer = false,
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.8,
            height = 0.6,
            preview_width = 0.5,
          },
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        },
        lsp_workspace_symbols = {
          initial_mode = "normal",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.8,
            preview_width = 0.5,
          },
          symbol_width = 50,
          symbol_type_width = 12,
          show_line = true,
          fname_width = 30,
          previewer = true,
          path_display = { "tail" },
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        },
        lsp_workspace_diagnostics = {
          layout_strategy = "horizontal",
        },
        oldfiles = {
          -- path_display = { "smart" },
          initial_mode = "insert",
        },
        buffers = {
          -- ignore_current_buffer = true,
          -- theme = "dropdown",
          -- Increase the previewer height ( and width )
          -- layout_config = {
          --   preview_width = 0.65,
          -- },
          ignore_current_buffer = true,
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "insert",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer, --+ actions.move_selection_next,
            },
            n = {
              ["<C-d>"] = actions.delete_buffer, --+ actions.move_selection_next,
            },
          },
        },
        find_files = {
          previewer = true,
          initial_mode = "insert",
          mappings = {
            i = {
              ["<M-y>"] = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local entries = picker:get_multi_selection()
                local file_names = utils.transform(entries, function(entry) return entry.path end)
                local joined_names = table.concat(file_names, "\n")
                vim.fn.setreg("+", joined_names)
                vim.notify("Yanked " .. #entries .. " files to the clipboard")
              end,
            },
          },
          hidden = true,
          no_ignore = false,
          follow = true,
        },
        -- theme = "ivy",
        jump_list = {
          initial_mode = "normal",
        },
        colorscheme = {
          mappings = {
            i = {
              ["<CR>"] = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local entry = picker:get_selection()
                actions.close(prompt_bufnr)
                require("user.util.theme").on_change(entry.value, { apply = true })
              end,
            },
            n = {
              ["<CR>"] = function(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local entry = picker:get_selection()
                actions.close(prompt_bufnr)
                require("user.util.theme").on_change(entry.value, { apply = true })
              end,
            },
          },
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          -- mappings = { -- extend mappings
          n = {
            ["<C-k>"] = function() require("telescope-live-grep-args.actions").quote_prompt() end,
            ["<C-i>"] = function() require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " } end,
          },
          i = {
            ["<C-k>"] = function() require("telescope-live-grep-args.actions").quote_prompt() end,
            ["<C-i>"] = function() require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " } end,
          },
          -- },
        },
        live_grep = {
          -- insert mode
          initial_mode = "insert",
          -- layout_strategy = "vertical",
          previewer = false,
          -- path_display = { "truncate" },
        },
        help_tags = {
          -- Ensure it doesn't open in a new split
          intial_mode = "insert",
          layout_strategy = "horizontal",
          mappings = {
            i = {
              -- Open in
              ["<CR>"] = to_win_or_tab,
            },
            n = {
              ["<CR>"] = to_win_or_tab,
            },
          },
        }, -- This closing brace was missing

        current_buffer_fuzzy_find = {
          skip_empty_lines = true,
          -- theme = "cursor",
        },
      },

      defaults = {
        -- border = false,
        layout_strategy = "vertical",
        history = {
          limit = 1000,
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--threads=8",
          "--hidden",
          "--trim",
          vim.tbl_map(function(pattern) return "--glob=!" .. pattern end, ignore_patterns),
        },
        color_devicons = true,
        git_worktrees = vim.g.git_worktrees,
        dynamic_preview_title = true,
        prompt_prefix = get_icon("Selected", 1),
        selection_caret = get_icon("Selected", 1),
        path_display = { "filename_first" },
        sorting_strategy = "ascending",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        -- Add file icons
        file_previewer = require("telescope.previewers").cat.new,
        grep_previewer = require("telescope.previewers").vimgrep.new,
        file_ignore_patterns = ignore_patterns,
        set_env = { COLORTERM = "truecolor" },
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        dynamic_preview_title = true,
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        selection_strategy = "reset",
        preview = {
          filesize_limit = 0.2, -- MB
          timeout = 150,
          treesitter = false,
          wrap_lines = true,
        },
        layout_config = {
          horizontal = {
            layout = "bottom_pane",
            prompt_position = "top", --[[  ]]
            preview_width = 0.50,
          },

          vertical = { mirror = false, preview_height = 0.5 },
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5,
          },
          cursor = {
            height = 0.9,
            preview_cutoff = 40,
            width = 0.8,
          },

          width = function(_, max_columns)
            local percentage = 0.99
            local max = 190
            return math.min(math.floor(percentage * max_columns), max)
          end,
          height = 0.999,
        },
        cycle_layout_list = { "horizontal", "vertical", "center", "cursor" },
        mappings = {

          i = {
            -- ["<C-j>"] = actions.move_selection_next,
            -- ["<C-k>"] = actions.move_selection_previous,
            ["<M-p>"] = layout.toggle_preview,
            -- ["<M-g>"] = preview_line_in_temporary_buffer,
            ["<M-CR>"] = function(prompt_bufnr) require("user.util.telescope.actions").open_selected(prompt_bufnr) end,
            ["<M-w>"] = function(prompt_bufnr)
              local timer = vim.loop.new_timer()
              timer:start(
                100,
                0,
                vim.schedule_wrap(function()
                  require("user.util.telescope.actions").live_grep_selected(prompt_bufnr)
                  timer:close()
                end)
              )
            end,
            ["<M-x>"] = function()
              require("telescope.actions.generate").refine(prompt_bufnr, {
                prompt_to_prefix = true,
                sorter = false,
              })
            end,
            --   end
            -- ["<M-BS"] = "<C-w>",
            -- ["<Esc>"] = function(prompt_bufnr)
            --   -- If no text is in the prompt, close the telescope
            --   local entry = action_state.get_current_line(prompt_bufnr)
            --   if entry == "" then actions.close(prompt_bufnr) end
            -- end,
            -- ["M-T"] = require("trouble.providers.telescope").open_with_trouble,
            --
            ["<M-x>"] = function(prompt_bufnr)
              local actions = require "telescope.actions"
              return actions.to_fuzzy_refine(prompt_bufnr)
            end,
          },

          n = {
            ["+"] = function(prompt_bufnr)
              -- toggle between different layout strategies
              local layout = require "telescope.actions.layout"
              layout.cycle_layout_next(prompt_bufnr)
            end,
            ["-"] = actions.cycle_previewers_prev,
            q = actions.close,
            -- ["M-T"] = require("trouble.providers.telescope").open_with_trouble,
            ["<M-w>"] = function(prompt_bufnr)
              local timer = vim.loop.new_timer()
              timer:start(
                100,
                0,
                vim.schedule_wrap(function()
                  require("user.util.telescope.actions").live_grep_selected(prompt_bufnr)
                  timer:close()
                end)
              )
            end,
            ["<M-p>"] = layout.toggle_preview,
            -- ["<C-j>"] = actions.move_selection_next,
            -- ["<C-k>"] = actions.move_selection_previous,
            ["<M-j>"] = actions.preview_scrolling_down,
            ["<M-k>"] = actions.preview_scrolling_up,
            ["<M-CR>"] = function(prompt_bufnr) require("user.util.telescope.actions").open_selected(prompt_bufnr) end,
            -- ["<M-g>"] = preview_line_in_temporary_buffer,
            ["<M-o>"] = function(prompt_bufnr)
              -- Use nvim-window-picker to choose the window by dynamically attaching a function
              local action_set = require "telescope.actions.set"

              action_state.get_current_picker(prompt_bufnr).get_selection_window = function(picker, entry)
                local picked_window_id = require("window-picker").pick_window {
                  filter_rules = {
                    include_current_win = true,
                  },
                }
                -- Unbind after using so next instance of the picker acts normally
                picker.get_selection_window = nil
                return picked_window_id
              end
              return action_set.edit(prompt_bufnr, "edit")
            end,
            ["<M-x>"] = function(prompt_bufnr)
              local actions = require "telescope.actions"
              return actions.to_fuzzy_refine(prompt_bufnr)
            end,
          },
        },
        -- Improve file sorting
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        -- Add file icons
        file_previewer = require("telescope.previewers").cat.new,
        grep_previewer = require("telescope.previewers").vimgrep.new,
        file_ignore_patterns = ignore_patterns,
        set_env = { COLORTERM = "truecolor" },
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        dynamic_preview_title = true,
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        selection_strategy = "reset",
      },
    }
  end,
  config = require "plugins.configs.telescope",
}
