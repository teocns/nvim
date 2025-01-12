return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    enabled = vim.env.DAP ~= nil,
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local dappy = require "dap-python"
      -- Extend opts table with justMyCode
      local pyutils = require "user.util.python_config"
      -- dappy.setup(pyutils.get_python_executable(), { include_configs = true })
      dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python", { include_configs = false })
      -- local utils = require "astronvim.utils"
      -- utils.set_mappings("dap.python", {
      --   n = {
      --     ["<leader>dk"] = { dappy.test_class, desc = "Run test class" },
      --     ["<leader>dm"] = { dappy.test_method, desc = "Run test method" },
      --   },
      -- })
    end,
  },
}
