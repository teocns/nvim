return {}
--
--
-- return {
--   "chentoast/marks.nvim",
--   event = "VeryLazy",
--   enabled = false,
--   opts = {
--     default_mappings = true,
--     force_write_shada = false,
--   },
--   -- keys = {
--   --   { "m", mode = { "n" } },
--   --   { "mx", function() require("marks").set_mark() end, mode = { "n" }, desc = "Set mark x" },
--   --   {
--   --     "m,",
--   --     function() require("marks").set_next_mark() end,
--   --     mode = { "n" },
--   --     desc = "Set the next available alphabetical (lowercase) mark",
--   --   },
--   --   {
--   --     "m;",
--   --     function() require("marks").toggle_mark() end,
--   --     mode = { "n" },
--   --     desc = "Toggle the next available mark at the current line",
--   --   },
--   --   { "dmx", function() require("marks").delete_mark() end, mode = { "n" }, desc = "Delete mark x" },
--   --   {
--   --     "dm-",
--   --     function() require("marks").delete_marks_on_line() end,
--   --     mode = { "n" },
--   --     desc = "Delete all marks on the current line",
--   --   },
--   --   {
--   --     "dm<space>",
--   --     function() require("marks").delete_all_marks() end,
--   --     mode = { "n" },
--   --     desc = "Delete all marks in the current buffer",
--   --   },
--   --   { "m]", function() require("marks").move_to_next_mark() end, mode = { "n" }, desc = "Move to next mark" },
--   --   { "m[", function() require("marks").move_to_previous_mark() end, mode = { "n" }, desc = "Move to previous mark" },
--   --   { "m:", function() require("marks").preview_mark() end, mode = { "n" }, desc = "Preview mark" },
--   --   {
--   --     "m[0-9]",
--   --     function() require("marks").add_bookmark() end,
--   --     mode = { "n" },
--   --     desc = "Add a bookmark from bookmark group[0-9]",
--   --   },
--   --   {
--   --     "dm[0-9]",
--   --     function() require("marks").delete_bookmarks() end,
--   --     mode = { "n" },
--   --     desc = "Delete all bookmarks from bookmark group[0-9]",
--   --   },
--   --   {
--   --     "m}",
--   --     function() require("marks").move_to_next_bookmark() end,
--   --     mode = { "n" },
--   --     desc = "Move to the next bookmark having the same type as the bookmark under the cursor",
--   --   },
--   --   {
--   --     "m{",
--   --     function() require("marks").move_to_previous_bookmark() end,
--   --     mode = { "n" },
--   --     desc = "Move to the previous bookmark having the same type as the bookmark under the cursor",
--   --   },
--   --   {
--   --     "dm=",
--   --     function() require("marks").delete_bookmark() end,
--   --     mode = { "n" },
--   --     desc = "Delete the bookmark under the cursor",
--   --   },
--   -- },
-- }
