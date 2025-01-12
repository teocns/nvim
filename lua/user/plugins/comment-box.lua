-- Your Neovim plugin configuration using packer.nvim or any other plugin manager
return {
  "LudoPinelli/comment-box.nvim",
  
  -- Ensure the plugin is loaded lazily
  lazy = true,

  opts = {
    comment_style = "auto",
    borders = { -- Symbols used to draw a box
      top = "═",
      bottom = "═",
      left = "║",
      right = "║",
      top_left = "╔",
      top_right = "╗",
      bottom_left = "╚",
      bottom_right = "╝",
    },
  },

  cmd = {
    "CBllbox",
    "CBlcbox",
    "CBlrbox",
    "CBclbox",
    "CBccbox",
    "CBcrbox",
    "CBrlbox",
    "CBrcbox",
    "CBrrbox",
    "CBlabox",
    "CBcabox",
    "CBrabox",

    "CBllline",
    "CBlcline",
    "CBlrline",
    "CBclline",
    "CBccline",
    "CBcrline",
    "CBrlline",
    "CBrcline",
    "CBrrline",

    "CBd",
  },

  keys = {
    -- Keybindings are handled via which-key in the config function
  },

  config = function()
    local wk = require("which-key")

    -- Define style lists
    local box_styles = {
      left = { "Classic", "Classic Heavy", "Dashed", "Dashed Heavy", "Double", "ASCII" },
      center = { "Classic", "Classic Heavy", "Dashed", "Dashed Heavy", "Double", "ASCII" },
      right = { "Classic", "Classic Heavy", "Dashed", "Dashed Heavy", "Double", "ASCII" },
    }

    local line_styles = {
      left = { "Simple", "Simple Heavy", "Confined", "Double", "ASCII" },
      center = { "Simple", "Simple Heavy", "Confined", "Double", "ASCII" },
      right = { "Simple", "Simple Heavy", "Confined", "Double", "ASCII" },
    }

    -- Style index trackers
    local current_box_style = {
      left = 1,
      center = 1,
      right = 1,
    }

    local current_line_style = {
      left = 1,
      center = 1,
      right = 1,
    }

    -- Function to detect orientation
    local function get_orientation()
      local line = vim.api.nvim_get_current_line()
      
      if line:match("^%s*╔") or line:match("^%s*┌") or line:match("^%s*┏") or line:match("^%s*┍") or line:match("^%s*╒") or line:match("^%s*╓") then
        return "left"
      elseif line:match("^%s*─") or line:match("^%s*═") then
        return "center"
      elseif line:match("^%s*╚") or line:match("^%s*└") or line:match("^%s*┗") or line:match("^%s*┕") or line:match("^%s*╘") or line:match("^%s*╙") then
        return "right"
      else
        return "left" -- Default orientation
      end
    end

    -- Function to check if inside a box or line
    local function is_inside_box_or_line()
      local line = vim.api.nvim_get_current_line()
      local patterns = {
        "^%s*[╔┌┏┍╒╓]", -- Top-left corners of boxes
        "^%s*[═─]",        -- Horizontal lines
        "^%s*[╚└┗┕╘╙]", -- Bottom-right corners of boxes
        "^%s*[║┃]",        -- Vertical borders of boxes
        "^%s*━",            -- Double lines
        "^%s*█",            -- Specific line styles like ASCII
        "^%s*+",            -- ASCII lines
      }

      for _, pat in ipairs(patterns) do
        if line:match(pat) then
          return true
        end
      end
      return false
    end

    -- Function to cycle box style
    local function cycle_box_style()
      local orientation = get_orientation()
      if not orientation then
        orientation = "left"
      end
      
      -- Increment the style index
      current_box_style[orientation] = current_box_style[orientation] % #box_styles[orientation] + 1
      local style = box_styles[orientation][current_box_style[orientation]]
      
      -- Remove existing box or line
      vim.cmd("CBd")
      
      -- Apply the new box style based on orientation and style
      local style_map = {
        left = {
          ["Classic"] = "CBllbox2",
          ["Classic Heavy"] = "CBllbox3",
          ["Dashed"] = "CBllbox4",
          ["Dashed Heavy"] = "CBllbox5",
          ["Double"] = "CBllbox7",
          ["ASCII"] = "CBllbox10",
        },
        center = {
          ["Classic"] = "CBclbox2",
          ["Classic Heavy"] = "CBclbox3",
          ["Dashed"] = "CBclbox4",
          ["Dashed Heavy"] = "CBclbox5",
          ["Double"] = "CBclbox7",
          ["ASCII"] = "CBclbox10",
        },
        right = {
          ["Classic"] = "CBrlbox2",
          ["Classic Heavy"] = "CBrlbox3",
          ["Dashed"] = "CBrlbox4",
          ["Dashed Heavy"] = "CBrlbox5",
          ["Double"] = "CBrlbox7",
          ["ASCII"] = "CBrlbox10",
        },
      }
      
      local cmd = style_map[orientation][style]
      if cmd then
        vim.cmd(cmd .. "<CR>")
      else
        print("Unknown box style: " .. style)
      end
    end

    -- Function to cycle line style
    local function cycle_line_style()
      local orientation = get_orientation()
      if not orientation then
        orientation = "left"
      end
      
      -- Increment the style index
      current_line_style[orientation] = current_line_style[orientation] % #line_styles[orientation] + 1
      local style = line_styles[orientation][current_line_style[orientation]]
      
      -- Remove existing box or line
      vim.cmd("CBd")
      
      -- Apply the new line style based on orientation and style
      local style_map = {
        left = {
          ["Simple"] = "CBllline1",
          ["Simple Heavy"] = "CBllline9",
          ["Confined"] = "CBllline10",
          ["Double"] = "CBllline13",
          ["ASCII"] = "CBllline15",
        },
        center = {
          ["Simple"] = "CBccline1",
          ["Simple Heavy"] = "CBccline9",
          ["Confined"] = "CBccline10",
          ["Double"] = "CBccline13",
          ["ASCII"] = "CBccline15",
        },
        right = {
          ["Simple"] = "CBrrline1",
          ["Simple Heavy"] = "CBrrline9",
          ["Confined"] = "CBrrline10",
          ["Double"] = "CBrrline13",
          ["ASCII"] = "CBrrline15",
        },
      }
      
      local cmd = style_map[orientation][style]
      if cmd then
        vim.cmd(cmd .. "<CR>")
      else
        print("Unknown line style: " .. style)
      end
    end

    -- Main function to handle <C-k> press
    local function handle_ctrl_k()
      if is_inside_box_or_line() then
        -- Determine if it's a box or a line based on the current line's characters
        local line = vim.api.nvim_get_current_line()
        if line:match("[╔┌┏┍╒╓]") or line:match("[║┃]") then
          -- It's a box
          cycle_box_style()
        elseif line:match("[─═━█+─]") then
          -- It's a line
          cycle_line_style()
        else
          -- Default to box if unsure
          cycle_box_style()
        end
      else
        -- If not inside a box or line, create a default box
        cycle_box_style()
      end
    end

    -- Register the <C-k> keybinding in Normal Mode
    vim.api.nvim_set_keymap('n', '<C-k>', '', { noremap = true, silent = true, callback = handle_ctrl_k })

    -- Optionally, register with which-key for descriptions
    wk.register({
      ["<C-k>"] = {
        name = "Cycle Box/Line Styles",
        [""] = { "<cmd>lua handle_ctrl_k()<cr>", "Cycle to Next Style" },
      },
    }, { prefix = "" })
  end,
}
