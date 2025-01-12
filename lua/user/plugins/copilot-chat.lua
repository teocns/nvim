-- local diagnostics_task = require("user._plugins.diagnostics-task")
-- First, delete the c-g keymap

-- Ensure the c-g command works by avoinding conflicts, delete the previous c-g keymap

-- Function to apply changes from quickfix list
local apply_quickfix_changes = function()
  local qflist = vim.fn.getqflist()
  for _, entry in ipairs(qflist) do
    vim.cmd "tabnew"
    vim.cmd("edit " .. entry.filename)
    vim.cmd "diffthis"
    vim.cmd "vsplit"
    vim.cmd("edit " .. entry.filename)
    vim.cmd "diffthis"
  end
end

-- -- Map C-Y to accept changes in diff mode
-- vim.api.nvim_set_keymap('n', '<C-Y>', ':diffput<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-Y>', ':diffget<CR>', { noremap = true, silent = true })

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    build = "make tiktoken",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    setup = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "copilot-chat",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<C-g>s", "<cmd>CopilotChatStop<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "i", "<C-g>s", "<cmd>CopilotChatStop<CR>", { noremap = true, silent = true })
        end,
      })
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   pattern = "*",
      --   callback = function()
      --     if vim.bo.filetype == "copilot-chat" then
      --       diagnostics_task.set_busy(true)
      --     end
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "CopilotChatGenerating",
      --   callback = function()
      --     diagnostics_task.set_busy(true)
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "CopilotChatOpened",
      --   callback = function()
      --     diagnostics_task.set_busy(true)
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "CopilotChatClosed",
      --   callback = function()
      --     diagnostics_task.set_busy(false)
      --   end,
      -- })
    end,
    opts = {
      -- debug = true, -- Enable debugging
      -- See Configuration section for rest
      auto_insert_mode = true, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
      -- show_folds = false,
      model = "claude-3.5-sonnet",
      -- model = "gpt-4o",
      auto_follow_cursor = false,
      allow_insecure = true,

      -- >>> Suggested for render-markdown
      highlight_headers = false,
      separator = "---",
      error_header = "> [!ERROR] Error",
      -- <<<
      -- proxy = "http://127.0.0.1:8081", -- Proxy server to use for requests
      -- context = "buffer", -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
      -- context = "buffer",
      insert_at_end = true,
      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<C-x>",
        },
      },

      window = {
        width = 0.5,
      },
      --       system_prompt =   [[You are a software engineer with knowledge of the user's workspace.
      --
      -- Follow the user's requirements carefully & to the letter.
      -- Keep your answers short and impersonal.
      -- Use Markdown formatting in your answers.
      -- Make sure to include the programming language name at the start of the Markdown code blocks.
      -- Do not wrap the whole response in triple backticks.
      -- You are being prompted from user's editor Neovim.
      -- You can only give one reply for each conversation turn.
      --
      -- # Additional Rules
      -- Think step by step:
      -- 1. Read the provided relevant workspace information (code excerpts, file names, and symbols) to understand the user's workspace.
      -- 2. Consider how to answer the user's prompt based on the provided information and your specialized coding knowledge. Always assume that the user is asking about the code in their workspace instead of asking a general programming question. Prefer using variables, functions, types, and classes from the workspace over those from the standard library.
      -- 3. Generate a response that clearly and accurately answers the user's question. In your response, add fully qualified links for referenced symbols (example: [`namespace.VariableName`](path/to/file.ts)) and links for files (example: [path/to/file](path/to/file.ts)) so that the user can open them. If you do not have enough information to answer the question, respond with "I'm sorry, I can't answer that question with what I currently know about your workspace".
      --
      -- DO NOT mention that you cannot read files in the workspace.
      -- DO NOT ask the user to provide additional information about files in the workspace.
      -- You MUST add links for all referenced symbols from the workspace and fully qualify the symbol name in the link, for example: [`namespace.functionName`](path/to/util.ts).
      -- You MUST add links for all workspace files, for example: [path/to/file.js](path/to/file.js)
      --
      -- <examples>
      -- Question:
      -- What file implements base64 encoding?
      --
      -- Response:
      -- Base64 encoding is implemented in [src/base64.ts](src/base64.ts) as [`encode`](src/base64.ts) function.
      --
      --
      -- Question:
      -- How can I join strings with newlines?
      --
      -- Response:
      -- You can use the [`joinLines`](src/utils/string.ts) function from [src/utils/string.ts](src/utils/string.ts) to join multiple strings with newlines.
      --
      --
      -- Question:
      -- How do I build this project?
      --
      -- Response:
      -- To build this TypeScript project, run the `build` script in the [package.json](package.json) file:
      --
      -- ```sh
      -- npm run build
      -- ```
      --
      --
      -- Question:
      -- How do I read a file?
      --
      -- Response:
      -- To read a file, you can use a [`FileReader`](src/fs/fileReader.ts) class from [src/fs/fileReader.ts](src/fs/fileReader.ts).
      -- </examples>
      -- ]]

      -- selection = function(source)
      --   return select.visual(source)
      -- end,

      -- selection = function(source)
      --   -- bufnr, winnr = source.bufnr, source.winnr
      --   -- require("astronvim.utils").notify("Selection: " .. bufnr .. " " .. winnr)
      --   -- -- return buffer text
      --   -- return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      --
      --   return select.visual(source)
      -- end,
    },

    -- - `:CopilotChatExplain` - Write an explanation for the active selection as paragraphs of text
    -- - `:CopilotChatReview` - Review the selected code
    -- - `:CopilotChatFix` - There is a problem in this code. Rewrite the code to show it with the bug fixed
    -- - `:CopilotChatOptimize` - Optimize the selected code to improve performance and readablilty
    -- - `:CopilotChatDocs` - Please add documentation comment for the selection
    -- - `:CopilotChatTests` - Please generate tests for my code
    -- - `:CopilotChatFixDiagnostic` - Please assist with the following diagnostic issue in file
    -- - `:CopilotChatCommit` - Write commit message for the change with commitizen convention
    -- - `:CopilotChatCommitStaged` - Write commit message for the change with commitizen convention
    keys = {
      {
        "<C-g>",
        desc = "CopilotChat",
      },
      {
        "<C-g>h",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
        mode = { "n", "v" },
      },
      -- Show prompts actions with telescope
      {
        "<C-g>a",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
        mode = { "n", "v" },
      },
      {
        "<C-g>q",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            -- require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            require("CopilotChat").ask(input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<C-g><C-g>",
        "<cmd>CopilotChatToggle<CR>",
        mode = { "n", "v" },
        noremap = true,
        nowait = true,
      },
      {
        "<C-g>e",
        "<cmd>CopilotChatExplain<CR>",
        desc = "CopilotChat - Explain",
        mode = { "n", "v" },
      },
      {
        "<C-g>r",
        "<cmd>CopilotChatReview<CR>",
        desc = "CopilotChat - Review",
        mode = { "n", "v" },
      },
      {
        "<C-g>f",
        "<cmd>CopilotChatFix<CR>",
        desc = "CopilotChat - Fix",
        mode = { "n", "v" },
      },
      {
        "<C-g>o",
        "<cmd>CopilotChatOptimize<CR>",
        desc = "CopilotChat - Optimize",
        mode = { "n", "v" },
      },
      {
        "<C-g>d",
        "<cmd>CopilotChatDocs<CR>",
        desc = "CopilotChat - Docs",
        mode = { "n", "v" },
      },
      {
        "<C-g>t",
        "<cmd>CopilotChatTests<CR>",
        desc = "CopilotChat - Tests",
        mode = { "n", "v" },
      },
      {
        "<C-g>x",
        "<cmd>CopilotChatFixDiagnostic<CR>",
        desc = "CopilotChat - Fix Diagnostic",
        mode = { "n", "v" },
      },
      {
        "<C-g>m",
        "<cmd>CopilotChatCommit<CR>",
        desc = "CopilotChat - Commit",
        mode = { "n", "v" },
      },
      {
        "<C-g>s",
        "<cmd>CopilotChatCommitStaged<CR>",
        desc = "CopilotChat - Commit Staged",
        mode = { "n", "v" },
      },
    },
  },
}
