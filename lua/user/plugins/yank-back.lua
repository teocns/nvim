return {
  "ptdewey/yankbank-nvim",
  config = function() require("yankbank").setup() end,

  dev = true,

  keys = {
    {
      "<leader>fy",
      desc = "open yanks",
      "<cmd>Telescope yankbank<cr>",
    },
  },
}
