local C = require("astronvim.utils.status.env").fallback_colors
-- local get_hl_group = require("astronvim.utils").get_hlgroup
return { -- this table overrides highlights in all themes
  -- VertSplit = { bg = "NONE", fg = C.fg },
  CmpItemKindCody = { bg = C.dark_bg, fg = C.fg },
  LeapBackdrop = { link = "Comment" },

  -- SignColumn = { bg = "NONE" },

  -- IndentBlankLine = { fg = C.blue },

  TelescopePromptNormal = {
    bg = "NONE",
    fg = "NONE",
  },
  TelescopePromptBorder = {
    bg = "NONE",
    fg = "NONE",
  },

  TelescopeNormal = {
    bg = "NONE",
  },

  -- hi DiffAdd guifg=#1a1d23 guibg=#a6e22e
  -- hi DiffChange guifg=#1a1d23 guibg=#f0c674
  -- hi DiffDelete guifg=#1a1d23 guibg=#ff6c6b
  -- hi DiffText guifg=#1a1d23 guibg=#ffd700

  DiffAdd = { bg = "#1d3521", fg = "#98b396" },
  DiffChange = { bg = "#2a2a1d", fg = "#c0c0a2" },
  DiffDelete = { bg = "#3f2121", fg = "#c49ea0" },
  DiffText = { bg = "#21283b", fg = "#a2b4cf" },

  -- Darken the background and slightly increase the contrast of the text
  Pmenu = { bg = "#121212", fg = "#c5c8c6" }, -- Darker background, softer text

  -- Make the selected item more distinct while maintaining a soft blue highlight
  PmenuSel = { bg = "#005f87", fg = "#ffffff" }, -- Darker blue for selection highlight

  -- Scroll bar and thumb, darker and subtler
  PmenuSbar = { bg = "#2a2a2a" }, -- Darker gray for the scroll bar
  PmenuThumb = { bg = "#005f87" }, -- Matching blue for the thumb, slightly toned down

  -- Float border adjustments, more subtle gray tones
  FloatBorder = { bg = "#121212", fg = "#2e2e2e" }, -- Subtle dark gray for the border, matching the dark theme

  -- DiagnosticError = { fg = "#6a737d" },

  -- ["@spell"] = { link = "NormalNC" },

  -- Use a darker border with a lighter gray-blue for borders
  -- TelescopePromptTitle = { fg = ss.bg.floating, bg = ss.syntax.keyword, bold = true },
  -- TelescopePromptPrefix = { fg = ss.diagnostics.hint },
  -- TelescopePromptCounter = { fg = ss.diagnostics.hint },
  -- TelescopePromptNormal = { bg = ss.bg.cursorline },
  -- TelescopePromptBorder = { fg = ss.bg.cursorline, bg = ss.bg.cursorline },
  --
  -- TelescopeResultsTitle = { fg = ss.bg.floating, bg = ss.bg.floating, bold = true },
  -- TelescopeResultsNormal = { bg = ss.bg.floating },
  -- TelescopeResultsBorder = { fg = ss.bg.floating, bg = ss.bg.floating },
  --
  -- TelescopePreviewTitle = { fg = ss.bg.floating, bg = ss.syntax.string, bold = true },
  -- TelescopePreviewNormal = { bg = ss.bg.floating },
  -- TelescopePreviewBorder = { fg = ss.bg.floating, bg = ss.bg.floating },

  -- VertSplit = { fg = "#3a3e47" },
  -- TelescopePromptTitle = {
  --   fg = "fg",
  -- },
  -- TelescopePreviewTitle = { bg = "NONE", fg = "fg" },
  -- TelescopeResultsTitle = {
  --   bg = "NONE",
  --   fg = "fg",
  -- },
  -- TelescopeBorder = {
  --   bg = "bg",
  --   fg = "bg",
  -- },

  -- Lighter magenta version
  -- PMenu = { bg = "#3c3f4a", fg = "#d0d0d0" },
  -- NormalFloat = { link = PMenu },
  -- NonText = { guifg = "#707275", fg = "#707275", bg = "NONE", ctermfg = "#707275" },

  -- ["@repeat"] = { link = "@keyword.repeat" },
  -- ["@debug"] = { link = "@keyword.debug" },
  -- ["@include"] = { link = "@keyword.include" },
  -- ["@exception"] = { link = "@keyword.exception" },
  -- ["@keyword"] = { link = "Keyword" },
  -- ["@keyword.corotine"] = { link = "Keyword" },
  -- ["@keyword.function"] = { link = "Keyword" },
  -- ["@keyword.operator"] = { link = "Keyword" },
  -- ["@keyword.import"] = { link = "Include" },
  -- ["@keyword.type"] = { link = "Typedef" },
  -- ["@keyword.modifier"] = { link = "Structure" },
  -- ["@keyword.repeat"] = { link = "Repeat" },
  -- ["@keyword.return"] = { link = "Keyword" },
  -- ["@keyword.debug"] = { link = "Debug" },
  -- ["@keyword.exception"] = { link = "Exception" },
  --
  -- ["@keyword.conditional"] = { link = "Conditional" },
  -- ["@keyword.conditional.ternary"] = { link = "@keyword.conditional" },
  -- --
  -- ["@keyword.directive"] = { link = "Keyword" },
  -- ["@keyword.directive.define"] = { link = "Keyword" },
  -- ["@method.call"] = { link = "Special" },
  -- ["@conditional"] = { link = "Conditional" },

  -- # https://neovim.io/doc/user/syntax.html

  -- Normal = {  bg ="NONE" },
  -- NormalNC = { bg = "NONE" },
  -- SignColumn = { bg = "NONE" },
  -- TabLine = { bg = "NONE" },
  -- Folded = { bg = "NONE" },
  -- WinBar = { bg = "NONE" },
  -- WinBarNC = { bg = "NONE" },
  -- AvanteConflictIncoming

  -- Results area with softer colors
  -- TelescopeResultsNormal = { bg = "#1E1E1E" },
  -- TelescopePreviewNormal = { bg = "#1E1E1E" },


  -- -- More muted result colors
  -- TelescopeResultsIdentifier = { fg = "#7FAFDF" }, -- Softer blue
  -- TelescopeResultsFunction = { fg = "#BCBC9C" }, -- Muted yellow
  -- TelescopeSelection = { fg = "#FFFFFF", bg = "#2F3D4F" }, -- Darker selection

  -- -- Softer matching
  -- TelescopeMatching = { fg = "#D4976C", bold = true }, -- Muted orange

  -- -- Multi-selection
  -- TelescopeMultiSelection = { fg = "#FFFFFF", bg = "#04395E" },
  -- TelescopeMultiIcon = { fg = "#007ACC" },

  -- -- Path display
  TelescopePathSeparator = { fg = "#808080" }, -- Subtle gray for path separators
}
