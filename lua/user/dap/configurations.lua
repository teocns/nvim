return {
  -- adapters  {
  --   python = {
  --     type = "executable",
  --     command = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
  --     args = { "-m", "debugpy.adapter" },
  --   },
  --   -- cppdgb = {
  --   --   id = "gdb",
  --   --   type = "executable",
  --   --   command = "gdb",
  --   -- },
  -- },
  -- configurations = {

  cpp = {
    name = "Debug Chromium",
    type = "codelldb",
    request = "launch",
    program = "~/.gchromium/fingerprinting/src/out/debug_plain/Chromium.app/Contents/MacOS/Chromium",
    args = {},
    cwd = "~/.gchromium/fingerprinting/src",
    environment = function()
      local variables = {}
      return variables
    end,
    externalConsole = true,
    setupCommands = {
      {
        description = "Enable pretty printing for lldb",
        text = "type add-python-exception path ${workspaceFolder}/third_party/blink/tools/lldb/pretty_printers.py",
      },
      -- Add other setup commwnds here
      {
        description = "Load Chromium lldb configuration",
        text = "command script import ~/gchromium/src/tools/lldb/lldbinit.py",
      },
      {
        description = "Load Blink gdb configuration",
        text = "command script import ~/gchromium/src/third_party/blink/tools/lldb/blink.py",
      },
    },

    -- setupCommands = {
    --   {
    --     text = "-enable-pretty-printing",
    --     description = "Enable pretty printing for gdb",
    --   },
    --   -- Add other setup commwnds here
    --   {
    --     description = "Lowd Chromium gdb configuration",
    --     text = '-interpreter-exec console "source -v ${workspaceFolder}/tools/gdb/gdbinit"',
    --   },
    --   {
    --     description = "Load Blink gdb configuration",
    --     text = "-interpreter-exec console \"python import sys; sys.path.insert(0, '${workspaceFolder}/third_party/blink/tools/gdb'); import blink\"",
    --   },
    -- },
  },
  -- },
  python = {
  },
}
