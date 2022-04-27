local gps = require("nvim-gps")

local gl = require("galaxyline")
local colors = require("galaxyline.themes.colors")["doom-one"]

local condition = require("galaxyline.condition")
local fileinfo  = require('galaxyline.providers.fileinfo')

local colors = {
  bg = '#282c34',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#0087d7',
  red = '#ec5f67'
}

local vim_modes = {
  n = "NORMAL",
  i = "INSERT",
  c = "COMMAND",
  v = "VISUAL",
  V = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
}

gl.short_line_list = { "NvimTree", "vista", "dbui", "packer" }
local gls = gl.section

gls.left[1] = {
  FirstElement = {
    provider = function()
      return "▋"
    end,
    highlight = { colors.blue, colors.yellow },
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      return vim_modes[vim.fn.mode()]
    end,
    separator = "",
    separator_highlight = {
      colors.purple,
      function()
        if not condition.buffer_not_empty() then
          return colors.purple
        end
        return colors.darkblue
      end,
    },
    highlight = { colors.darkblue, colors.purple, "bold" },
  },
}
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {fileinfo.get_file_icon_color, colors.darkblue},
  },
}
gls.left[4] = {
  FileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = { colors.magenta, colors.darkblue, "bold" },
    separator = "",
    separator_highlight = { colors.purple, colors.darkblue },
  },
}
gls.left[5] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.violet, colors.purple, "bold" },
  },
}
gls.left[6] = {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = { colors.grey, colors.purple },
    highlight = { colors.grey, colors.purple, "bold" },
  },
}
gls.left[7] = {
  DiffAdd = {
    provider = "DiffAdd",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = { colors.green, colors.purple },
  },
}
gls.left[8] = {
  DiffModified = {
    provider = "DiffModified",
    condition = condition.hide_in_width,
    icon = " 柳",
    highlight = { colors.orange, colors.purple },
  },
}
gls.left[9] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = { colors.red, colors.purple },
  },
}
gls.left[10] = {
  LeftEnd = {
    provider = function()
      return ""
    end,
    separator = "",
    separator_highlight = { colors.purple, colors.bg },
    highlight = { colors.purple, colors.purple },
  },
}
gls.left[11] = {
  CurrentFunction = {
    provider = function()
        return gps.get_location()
    end,
    condition = function()
        return condition.hide_in_width() and gps.is_available()
    end,
    icon = " ",
    separator = " ",
    separator_highlight = { colors.bg, colors.bg },
    highlight = { colors.blue, colors.bg },
  },
}
gls.left[12] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = { colors.red, colors.bg },
  },
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = { colors.yellow, colors.bg },
  },
}
-- gls.left[13] = {
--   DiagnosticHint = {
--     provider = "DiagnosticHint",
--     icon = "  ",
--     highlight = { colors.cyan, colors.bg },
--   },
-- }
-- gls.left[14] = {
--   DiagnosticInfo = {
--     provider = "DiagnosticInfo",
--     icon = "  ",
--     highlight = { colors.blue, colors.bg },
--   },
-- }

gls.right[1] = {
  FileEncode = {
    provider = "FileEncode",
    separator = '',
    separator_highlight = {colors.purple, colors.bg},
    highlight = { colors.grey, colors.purple },
  },
}
gls.right[2] = {
  FileFormat = {
    provider = function()
      local format_icon = {['DOS'] = " ", ['MAC'] = " ", ['UNIX'] = " "}
      return " " .. format_icon[fileinfo.get_file_format()]
    end,
    separator = " ",
    separator_highlight = { colors.bg, colors.purple },
    highlight = { colors.grey, colors.purple },
  },
}
gls.right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = '',
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.grey, colors.bg},
  },
}
gls.right[4] = {
  PerCent = {
    provider = 'LinePercent',
    separator = '',
    separator_highlight = {colors.purple, colors.darkblue},
    highlight = {colors.grey, colors.purple},
  }
}
gls.right[5] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.yellow, colors.purple},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.grey,colors.purple}
  }
}
gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    separator_highlight = {colors.purple,colors.bg},
    highlight = {colors.grey,colors.purple}
  }
}
