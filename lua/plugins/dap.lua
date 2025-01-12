return {
  "mfussenegger/nvim-dap",
  enabled = vim.env.DAP ~= nil,
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "nvim-dap" },
      cmd = { "DapInstall", "DapUninstall" },
      opts = { handlers = {} },
    },
    {
      "rcarriga/nvim-dap-ui",
      opts = { floating = { border = "rounded" } },
      config = require "plugins.configs.nvim-dap-ui",
    },
    {
      "rcarriga/cmp-dap",
      ft = { "dap-repl", "dapui_watches", "dapui_hover" },
      dependencies = { "nvim-cmp" },
      config = require "plugins.configs.cmp-dap",
    },
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debugger: Start" },
    { "<F17>", function() require("dap").terminate() end, desc = "Debugger: Stop" }, -- Shift+F5
    {
      "<F21>",
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      desc = "Debugger: Conditional Breakpoint",
    },
    { "<F29>", function() require("dap").restart_frame() end, desc = "Debugger: Restart" }, -- Control+F5
    { "<F6>", function() require("dap").pause() end, desc = "Debugger: Pause" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debugger: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debugger: Step Into" },
    { "<F23>", function() require("dap").step_out() end, desc = "Debugger: Step Out" }, -- Shift+F11
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
    { "<leader>dB", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Start/Continue (F5)" },
    {
      "<leader>dC",
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      desc = "Conditional Breakpoint (S-F9)",
    },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (F11)" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over (F10)" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out (S-F11)" },
    { "<leader>dq", function() require("dap").close() end, desc = "Close Session" },
    { "<leader>dQ", function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause (F6)" },
    { "<leader>dr", function() require("dap").restart_frame() end, desc = "Restart (C-F5)" },
    { "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },

    -- maps.v["<leader>dE"] = { function() require("dapui").eval() end, desc = "Evaluate Input" }
    -- maps.n["<leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }
    -- maps.n["<leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }

    {
      "<leader>dE",
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr, { enter = true }) end
        end)
      end,
      desc = "Evaluate Input",
      mode = "v",
    },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" },
  },
  event = "User AstroFile",
}
