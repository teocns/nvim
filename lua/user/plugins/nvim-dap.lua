return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    local pyutils = require "user.util.python_config"
    -- dap.adapters.lldb = dap.adapters.codelldb

    require("dap.ext.vscode").load_launchjs(nil, { lldb = { "cpp", "c" } })

    dap.defaults.fallback.exception_breakpoints = { "uncaught" }

    dap.adapters.lldb = {
      type = "executable",
      command = "~/clang+llvm-17.0.6-arm64-apple-darwin22.0/bin/lldb-vscode",
      name = "lldb",
    }
    -- vim.keymap.set("n", "<leader>dL", function() require("osv").launch { port = 8086 } end)
    -- On the other side, run `lua require"osv".launch({port=8086})`
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
      -- {
      --     name = "Start server",
      --     type = "nlua",
      --     request = "launch",
      --     args = {
      --         "--headless",
      --         "-c", "lua require('osv').launch({port=8086})",
      --         "-c", "quit"
      --     }
      -- },
      -- {
      --   name = "Start server",
      --   request = "launch",
      --   type = "nlua",
      --   cwd = vim.fn.getcwd(),
      --   args = { "-e", "require('osv').launch({port=8086})" },
      -- }
    }

    dap.adapters.nlua = function(callback, config)
      callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
    end
    -- If dap.configurations.lua isn't a table value
    if type(dap.configurations.cpp) ~= "table" then dap.configurations.cpp = {} end

    table.insert(dap.configurations.cpp, {
      name = "(lldb) Attach PID",
      type = "lldb",
      request = "attach",
      rootPath = "${workspaceFolder}",
      program = "${workspaceFolder}/out/debug_plain/Chromium.app/Contents/MacOS/Chromium",
      -- attach = {
      --   pidProperty = "pid",
      --   pidSelect = "ask",
      -- },
      -- processId = function()
      --   local ret = require("dap.utils").pick_process
      --   require("notify")("ret: " .. ret)
      -- end,
      cwd = "${workspaceFolder}/out/debug_plain",
      targetArchitecture = "arm64",
      externalConsole = false,
      integratedTerminal = false,
      MIMode = "lldb",
    })

    -- python = dap.configurations.python or {}

    local bin = pyutils.get_python_executable()
    dap.configurations.python = {

      {
        console = "integratedTerminal",
        name = "Python: Launch file w/ext",
        justMyCode = false,
        runInTerminal = true,
        program = "${file}",
        python = { bin, "-E" },
        redirectOutput = true,
        showReturnValue = true,
        request = "launch",
        type = "python",
      },
      {
        name = "Pytest: Current File",
        type = "python",
        request = "launch",
        redirectOutput = true,
        justMyCode = false,
        module = "pytest",
        args = {
          "${file}",
          "-sv",
          "--log-cli-level=INFO",
          "--log-file=test_out.log",
        },
        console = "integratedTerminal",
      },
      {
        name = "Pytest: Run Current Function",
        type = "python",
        request = "launch",
        redirectOutput = true,
        justMyCode = false,
        module = "pytest",
        args = {
          "${file}:${selectedText}",
          "-sv",
          "--log-cli-level=INFO",
          "--log-file=test_out.log",
        },
        console = "integratedTerminal",
      },
    }
    -- Create attach configuration for C++ using lldb (renderer process)
    -- This might be called from an already existing debug session
    -- Try to detect and list the processes to attach

    -------------------------------------------------------------
    -- TYPESCRIPT
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          require("mason-registry").get_package("js-debug-adapter"):get_install_path()
          .. "/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }
    local js_config = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    if not dap.configurations.javascript then
      dap.configurations.javascript = js_config
    else
      utils.extend_tbl(dap.configurations.javascript, js_config)
    end
    -------------------------------------------------------------
  end,
}
