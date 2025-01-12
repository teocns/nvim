local C = require("astronvim.utils.status.env").fallback_colors
-- local get_hl_group = require("astronvim.utils").get_hlgroup
return { -- this table overrides highlights in all themes
  -- Normal = { bg = "#000000" },
  -- VertSplit = { bg = "NONE", fg = C.fg },
  -- CmpItemKindCody = { bg = C.dark_bg, fg = C.fg },
  -- LeapBackdrop = { link = "Comment" },
  --
  -- -- TelescopePromptNormal = {
  -- --   bg = "NONE",
  -- --   fg = "NONE",
  -- -- },
  -- -- TelescopePromptBorder = {
  -- --   bg = "NONE",
  -- --   fg = "NONE",
  -- -- },
  -- TelescopePromptTitle = {
  --   fg = "fg",
  -- },
  -- TelescopePreviewTitle = { bg = "NONE", fg = "fg" },
  -- TelescopeResultsTitle= {
  --   bg = "NONE",
  --   fg = "fg",
  -- },
  -- TelescopeBorder = {
  --   bg = "bg",
  --   fg = "bg",
  -- }

  Macro = { link = "SpecialChar" },
  Keyword = { link = "SpecialChar" },
  ["@keyword"] = { link = "SpecialChar" },
}
