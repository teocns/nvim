C = require "ayu.colors"

-- local C = require("astronvim.utils.status.env").fallback_colors
return {
  -- Directory = { fg = "#666777" },
  -- Winbar = { fg = "#666777" },
  -- Greenish
  -- DiffAdd = { bg = "#a9f5a9" },
  -- TablineSel = { fg = "#f29718" },
  -- ToggleTerm101NormalFloat = { bg = "NONE", fg = "NONE" },
  -- Normal = { guibg = "NONE" },

  -- NormalFloat = { bg = "NONE", fg = "NONE" },
  -- VertSplit = { fg = "#636466" },
  -- VertSplit = { fg = "#000000" },
  -- treesitter namespace
  -- ["LeapLabelPrimary"] = { bg = "black", fg = "#E9FF81", bold = true },
  -- ["LeapBackdrop"] = { link = "Comment" },

  -- highlight CursorLine cterm=NONE ctermbg=darkgray guibg=#131721

  CursorLine = { bg = "#131721" },

  -- ["@namespace"] = { fg = "#9c8e73" },
  -- ["@lsp.type.namespace"] = { fg = "#9c8e73" },
  ["@lsp.type.builtin"] = { link = "@type" },
  ["@include"] = { link = "@keyword" },
  -- ["@Field"] = { fg = "#FFB454"},
  ["@conditional"] = { link = "@keyword.operator" },
  ["@exception"] = { link = "@keyword.operator" },
  ["@repeat"] = { link = "@keyword.operator" },
  ["yamlMappingKey"] = { fg = "#3bbae5" },
  ["@field.yaml"] = { fg = "#3bbae5" },
  ["@variable.parameter"] = { fg = "#D2A6FF" },
  ["LineNr"] = { fg = "#474B56" },

  -- keyword
  --
  -- punctuation
  -- ["@punctuation.delimiter"] = { fg = C.syntax.text },
  -- ["@punctuation.bracket"] = { fg = C.syntax.text },
  -- ["@punctuation.special"] = { fg = C.syntax.text },
  --
  -- -- comment
  -- ["@comment"] = { link = "Comment" },
  -- ["@comment.documentation"] = { link = "@comment" },
  --
  -- -- markup
  -- ["@markup.strong"] = { fg = C.syntax.text, bold = true },
  -- ["@markup.italic"] = { fg = C.syntax.text, italic = true },
  -- ["@markup.strikethrough"] = { fg = C.syntax.text, strikethrough = true },
  -- ["@markup.underline"] = { link = "Underline" },
  --
  -- ["@markup.heading"] = { fg = C.syntax.text, bold = true },
  -- ["@markup.heading.1.markdown"] = { fg = C.syntax.purple, bold = true },
  -- ["@markup.heading.2.markdown"] = { fg = C.syntax.blue, bold = true },
  -- ["@markup.heading.3.markdown"] = { fg = C.syntax.cyan, bold = true },
  -- ["@markup.heading.4.markdown"] = { fg = C.syntax.green, bold = true },
  -- ["@markup.heading.5.markdown"] = { fg = C.syntax.yellow, bold = true },
  --
  -- ["@markup.quote"] = { fg = C.syntax.text, italic = true },
  -- ["@markup.math"] = { fg = C.syntax.blue },
  -- ["@markup.environment"] = { fg = C.syntax.orange },
  --
  -- ["@markup.link"] = { fg = C.syntax.yellow, bold = true },
  -- ["@markup.link.label"] = { link = "String" },
  -- ["@markup.link.url"] = { fg = C.syntax.green, italic = true, underline = true },
  --
  -- ["@markup.raw"] = { fg = C.syntax.text },
  -- ["@markup.raw.block"] = { fg = C.syntax.text },
  --
  -- ["@markup.list"] = { link = "Special" },
  -- ["@markup.list.unchecked"] = { fg = C.ui.base, bg = C.ui.purple },
  -- ["@markup.list.checked"] = { fg = C.ui.base, bg = C.ui.green },
  --
  -- ["@diff.plus"] = { link = "DiffAdded" },
  -- ["@diff.minus"] = { link = "DiffDelete" },
  -- ["@diff.delta"] = { link = "DiffChange" },
  --
  -- ["@tag"] = { fg = C.syntax.red },
  -- ["@tag.attribute"] = { fg = C.syntax.cyan },
  -- ["@tag.delimiter"] = { fg = C.syntax.text },
}
