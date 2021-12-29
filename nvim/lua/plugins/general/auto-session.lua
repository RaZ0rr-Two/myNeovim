vim.cmd([[
	let session_path = expand('~/.config/nvim/.sessionDir')
	" create the directory and any parent directories
	" if the location does not exist.
	if !isdirectory(session_path)
			call mkdir(session_path, "p", 0700)
	endif
]])

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

local opts = {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.expand('~/.config/nvim/.sessionDir').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = nil,
  auto_restore_enabled = false,
}

require('auto-session').setup(opts)
