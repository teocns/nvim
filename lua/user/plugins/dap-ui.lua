return {
  "rcarriga/nvim-dap-ui",
  enabled = vim.env.DAP ~= nil,
  keys = {

    {
      "<leader>dl",
      function()
        require("dapui").float_element("console", {
          enter = true,
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
          position = "center",
        })
      end,
      desc = "Toggle DAP log",
    },
    {
      "<leader>dw",
      function() require("dapui").toggle(5) end,
      desc = "Toggle watches",
    },
    {
      "<leader>ds",
      function() require("dapui").toggle(4) end,
      desc = "Toggle scopes",
    },
    {
      "<leader>dt",
      function() require("dapui").toggle(3) end,
      desc = "Toggle trace",
    },
    {
      "<leader>dd",
      function() require("dapui").toggle(2) end,
      desc = "Toggle panel",
    },
    {
      "<leader>du",
      function() require("dapui").toggle(1) end,
      desc = "Toggle REPL",
    },
    -- { "<leader>dE", function() vim.ui.input({ prompt = "Expression: " }, function(expr) if expr then require("dapui").eval(expr, { enter = true }) end end) end, desc = "Evaluate Input", },,
    { "<leader>dE", function() require("dapui").eval() end, desc = "Evaluate Input", mode = "v" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" },
  },
  config = function(plugin, opts)
    local dap = require "dap"
    local dapui = require "dapui"
    -- setup
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open(1) end
    -- Open panel on breakpoint
    dap.listeners.after.event_breakpoint["dapui_config"] = function() dapui.open(2) end
    -- Close panel on exit
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end

    dapui.setup(opts)
  end,
  opts = {

    layouts = {
      {
        elements = {
          {
            id = "repl",
            size = 1,
          },
        },
        position = "bottom",
        size = 15,
      },
      {
        elements = {
          { -- Scope vars
            id = "scopes",
            size = 0.1,
          },
          { -- Call stack

            id = "stacks",
            size = 0.8,
          },
          {
            id = "breakpoints",
            size = 0.1,
          },
          -- {
          --   id = "watches",
          --   size = 0.25,
          -- },
        },
        position = "right",
        size = 0.50,
      },
      {
        elements = {
          { -- Call stack

            id = "stacks",
            size = 1,
          },
        },
        position = "right",
        size = 0.45,
      },
      {
        elements = {
          { -- Call stack

            id = "scopes",
            size = 1,
          },
        },
        position = "right",
        size = 0.45,
      },
      {
        elements = {
          { -- Scope vars
            id = "watches",
            size = 0.4,
          },
          {
            id = "scopes",
            size = 0.4,
          },
          { -- Call stack

            id = "stacks",
            size = 0.3,
          },
        },
        position = "right",
        size = 0.50,
      },
    },
  },
}
