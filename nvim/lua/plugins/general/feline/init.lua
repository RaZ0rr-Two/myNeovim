-- Reference:
-- 1) ibhagwan setup (https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugins/feline.lua)
-- 2)  crivotz/nv-ide setup (https://github.com/crivotz/nv-ide/blob/master/lua/plugins/feline.lua)

local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local force_inactive = {
	filetypes = {},
	buftypes = {},
	bufnames = {}
}

local components = {
	active = {{}, {}, {}},
	inactive = {{}, {}, {}},
}

local my_theme = {
	bg = '#282828',
	black = '#282828',
	yellow = '#d8a657',
	cyan = '#89b482',
	oceanblue = '#45707a',
	green = '#a9b665',
	orange = '#e78a4e',
	violet = '#d3869b',
	magenta = '#D16D9E',
	white = '#a89984',
	fg = '#a89984',
	skyblue = '#7daea3',
	red = '#ea6962',
	blue = '#61afef',
}

local vi_mode_colors = {
	NORMAL = 'green',
	OP = 'green',
	INSERT = 'red',
	VISUAL = 'magenta',
	LINES = 'magenta',
	BLOCK = 'magenta',
	REPLACE = 'violet',
	['V-REPLACE'] = 'violet',
	ENTER = 'cyan',
	MORE = 'cyan',
	SELECT = 'orange',
	COMMAND = 'green',
	SHELL = 'green',
	TERM = 'green',
	NONE = 'yellow'
}

local vi_mode_text = {
	NORMAL = '<|',
	OP = '<|',
	INSERT = '|>',
	VISUAL = '<>',
	LINES = '<>',
	BLOCK = '<>',
	REPLACE = '<>',
	['V-REPLACE'] = '<>',
	ENTER = '<>',
	MORE = '<>',
	SELECT = '<>',
	COMMAND = '<|',
	SHELL = '<|',
	TERM = '<|',
	NONE = '<>'
}

local icons = {
	linux = ' ',
	macos = ' ',
	windows = ' ',

	errs = ' ',
	warns = ' ',
	infos = ' ',
	hints = ' ',

	lsp = ' ',
	git = ''
}

local file_osinfo = function()
	local os = vim.bo.fileformat:upper()
	local icon
	if os == 'UNIX' then
		icon = icons.linux
	elseif os == 'MAC' then
		icon = icons.macos
	else
		icon = icons.windows
	end
	return icon .. os
end

local LinesInfo = function() 
	local line = vim.fn.line('.')
	local column = vim.fn.col('.')
	local total_line = vim.fn.line('$')
	return string.format("%d:%d  %d", column, line, total_line)
end

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
		return true
	end
	return false
end

local fullBar = function()
	return vim.api.nvim_win_get_width(0) > 75
end

local function is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
end

local checkwidth = function()
	local squeeze_width  = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

local function vimode_hl()
	return {
		name = vi_mode_utils.get_mode_highlight_name(),
		fg = vi_mode_utils.get_mode_color()
	}
end

force_inactive.filetypes = {
	'NvimTree',
	'fern',
	'dbui',
	'packer',
	'startify',
	'fugitive',
	'fugitiveblame'
}

force_inactive.buftypes = {
	'terminal'
}

local bordersDecor = {
	left = {
		provider = '▊',
		hl = vimode_hl,
		right_sep = ' '
	},
	right = {
		provider = '▊',
		hl = vimode_hl,
		left_sep = ' '
	}
}

-- LEFT

-- vi-mode
components.active[1][1] = {
	provider = '▊',
	hl = vimode_hl,
	-- right_sep = ' '
}
components.active[1][2] = {
	-- provider = ' NV-IDE ',
	provider = function()
		-- return '  ' .. vi_mode_utils.get_vim_mode()
		return vi_mode_utils.get_vim_mode()
	end,
	hl = function()
		local val = {}
		val.name = vi_mode_utils.get_mode_highlight_name()
		val.fg = vi_mode_utils.get_mode_color()
		val.bg = 'black'
		val.style = 'bold'
		return val
	end,
	icon = {
		str = '  ',
		hl = {
			name = 'StatusComponentVimMode',
			vimode_hl,
			style = 'bold',
		}
	},
	right_sep = {
		str = ' ',
		hl = {
			fg = 'black',
			bg = 'black'
		}
	}
}

-- vi-mode
components.active[1][3] = {
	provider = '',
	hl = function()
		local val = {}

		val.fg = 'yellow'
		val.bg = 'black'
		-- val.style = 'bold'

		return val
	end,
}

-- vi-symbol
-- components.active[1][2] = {
	--   provider = function()
		--     return vi_mode_text[vi_mode_utils.get_vim_mode()]
		--   end,
		--   hl = function()
			--     local val = {}
			--     val.fg = vi_mode_utils.get_mode_color()
			--     val.bg = 'bg'
			--     val.style = 'bold'
			--     return val
			--   end,
			--   right_sep = ' '
	-- }

-- filename
components.active[1][4] = {
	provider = {
		name = 'file_info',
		colored_icon = true,
		opts = {
			type = 'unique-short'
		}
	},
	icon = '',
	enabled = is_buffer_empty,
	hl = {
		fg = 'blue',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = " ",
	--left_sep = ' '
}

components.active[1][5] = {
	provider = ' ',
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	},
	-- right_sep = ' '
}

-- components.active[1][3] = {
	--   provider = function()
		--     return vim.fn.expand("%:F")
		--   end,
		--   hl = {
			--     bg = 'yellow',
			--     fg = 'bg',
			--     style = 'bold'
			--   },
			--   right_sep = ' '
			-- }

-- gitBranch
components.active[1][6] = {
	provider = 'git_branch',
	hl = {
		-- bg = 'yellow',
		fg = 'violet',
		style = 'bold'
	}
}
-- diffAdd
components.active[1][7] = {
	provider = 'git_diff_added',
	enabled = fullBar,
	hl = {
		fg = 'green',
		bg = 'bg',
		style = 'bold'
	}
}
-- diffModfified
components.active[1][8] = {
	provider = 'git_diff_changed',
	enabled = fullBar,
	hl = {
		fg = 'orange',
		bg = 'bg',
		style = 'bold'
	}
}
-- diffRemove
components.active[1][9] = {
	provider = 'git_diff_removed',
	enabled = fullBar,
	hl = {
		fg = 'red',
		bg = 'bg',
		style = 'bold'
	}
}

-- MID

-- LspName
components.active[2][1] = {
	provider = 'lsp_client_names',
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
}
-- diagnosticErrors
components.active[2][2] = {
	provider = 'diagnostic_errors',
	-- enabled = function() return lsp.diagnostics_exist('Error') end,
	enabled = require('feline.providers.lsp').diagnostics_exist(vim.diagnostic.severity.ERROR),
	hl = {
		fg = 'red',
		style = 'bold'
	}
}
-- diagnosticWarn
components.active[2][3] = {
	provider = 'diagnostic_warnings',
	enabled = require('feline.providers.lsp').diagnostics_exist(vim.diagnostic.severity.WARN),
	hl = {
		fg = 'yellow',
		style = 'bold'
	}
}
-- diagnosticHint
components.active[2][4] = {
	provider = 'diagnostic_hints',
	enabled = require('feline.providers.lsp').diagnostics_exist(vim.diagnostic.severity.HINT),
	hl = {
		fg = 'cyan',
		style = 'bold'
	}
}
-- diagnosticInfo
components.active[2][5] = {
	provider = 'diagnostic_info',
	enabled = require('feline.providers.lsp').diagnostics_exist(vim.diagnostic.severity.HINT),
	hl = {
		fg = 'skyblue',
		style = 'bold'
	}
}

-- RIGHT
-- fileIcon
components.active[3][1] = {
	provider = function()
		local filename = vim.fn.expand('%:t')
		local extension = vim.fn.expand('%:e')
		local icon  = require'nvim-web-devicons'.get_icon(filename, extension)
		if icon == nil then
			icon = ''
		end
		return icon
	end,
	-- enabled = fullBar,
	hl = function()
		local val = {}
		local filename = vim.fn.expand('%:t')
		local extension = vim.fn.expand('%:e')
		local icon, name  = require'nvim-web-devicons'.get_icon(filename, extension)
		if icon ~= nil then
			val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
		else
			val.fg = 'white'
		end
		val.bg = 'bg'
		val.style = 'bold'
		return val
	end,
	right_sep = ' '
}

-- fileType
components.active[3][2] = {
	provider = 'file_type',
	-- enabled = fullBar,
	hl = function()
		local val = {}
		local filename = vim.fn.expand('%:t')
		local extension = vim.fn.expand('%:e')
		local icon, name  = require'nvim-web-devicons'.get_icon(filename, extension)
		if icon ~= nil then
			val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
		else
			val.fg = 'white'
		end
		val.bg = 'bg'
		val.style = 'bold'
		return val
	end,
	right_sep = ' '
}
-- lineInfo
components.active[3][3] = {
	provider = LinesInfo,
	-- provider = 'position',
	hl = {
		fg = 'white',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
}
-- linePercent
components.active[3][4] = {
	provider = 'line_percentage',
	enabled = fullBar,
	hl = {
		fg = 'white',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
}
-- scrollBar
components.active[3][5] = {
	provider = 'scroll_bar',
	enabled = fullBar,
	right_sep = ' ',
	hl = {
		fg = 'magenta',
		style = 'bold'
	}
}
-- fileSize
components.active[3][6] = {
	provider = 'file_size',
	enabled = fullBar,
	hl = {
		fg = 'skyblue',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
}
-- fileFormat
components.active[3][7] = {
	provider = file_osinfo,
	enabled = fullBar,
	hl = function()
		local val = {}

		val.fg = vi_mode_utils.get_mode_color()
		val.bg = 'black'
		val.style = 'bold'

		return val
	end,
	--    hl = {
		-- fg = 'white',
		-- bg = 'bg',
		-- style = 'bold'
		--    },
	right_sep = ' '
}
-- fileEncode
components.active[3][8] = {
	provider = 'file_encoding',
	-- enabled = fullBar,
	hl = function()
		local val = {}

		val.fg = vi_mode_utils.get_mode_color()
		val.bg = 'black'
		val.style = 'bold'

		return val
	end,
	--    hl = {
	-- fg = 'white',
	-- bg = 'bg',
	-- style = 'bold'
	--    },
	-- right_sep = ' '
}

components.active[3][9] = bordersDecor.right

-- INACTIVE

-- fileType
components.inactive[1][1] = {
	provider = 'file_type',
	hl = {
		fg = 'black',
		bg = 'cyan',
		style = 'bold'
	},
	left_sep = {
		str = ' ',
		hl = {
			fg = 'NONE',
			bg = 'cyan'
		}
	},
	right_sep = {
		{
			str = ' ',
			hl = {
				fg = 'NONE',
				bg = 'cyan'
			}
		},
		' '
	}
}
-- require('feline').use_theme(my_theme)
require('feline').setup{
	theme = my_theme,
	-- theme = 'onedark',
	components = components,
	vi_mode_colors = vi_mode_colors,
	force_inactive = force_inactive,
}
