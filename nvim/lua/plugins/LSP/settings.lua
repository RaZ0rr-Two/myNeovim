--##########################################################################################################
-- LSP Keybindings and completion---------------------------------------------------------------------------
--###################################################################################################################

local nvim_lsp = require('lspconfig')
vim.lsp.set_log_level 'debug'
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>ee', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev { float = true }<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next { float = true }<CR>', opts)
	buf_set_keymap('n', '<space>lq', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap('n', '<space>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	-- require 'illuminate'.on_attach(client)
	require'aerial'.on_attach()
	if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
	end
	-- aerial.on_attach
end

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = "??? ", Warn = "??? ", Hint = "??? ", Info = "??? " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

--##########################################################################################################
-- General lang server setup -----------------------------------------
--###################################################################################################################

local server_config = {
	capabilities = capabilities;
	on_attach = on_attach;
	flags = {
		debounce_text_changes = 150,
	}
}

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { 'cmake','vimls'}
-- for _, lsp in ipairs(servers) do
-- 	nvim_lsp[lsp].setup { 
-- 		--root_dir = vim.loop.cwd;
-- 		capabilities = capabilities;
-- 		on_attach = on_attach;
-- 		flags = {
-- 			debounce_text_changes = 150,
-- 		}
-- 	}
-- end

-- nvim_lsp.bashls.setup { 
--     --root_dir = vim.loop.cwd;
--     filetypes = { "sh", "bash", "zsh" },
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = {
-- 			debounce_text_changes = 150,
--     }
-- }

--##########################################################################################################
-- C++ config------------------------------------------
--###################################################################################################################

nvim_lsp.clangd.setup {
	server_config,
	cmd = { 
		"clangd",  
		"--background-index",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	-- on_init = function to handle changing offsetEncoding
	-- root_dir = require('lspconfig/util').root_pattern("compile_commands.json", "compile_flags.txt", ".ccls"),
	-- root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git") or dirname
}

-- require('LSP/ccpp')
-- local cclscachepath = vim.fn.getenv("HOME").."/tmp/ccls-cache"
-- nvim_lsp.ccls.setup {
--     init_options = {
-- 	  --compilationDatabaseDirectory = "/home/ACM-Lab/Softwares/Installed/ccls/Debug" ;
-- 				index = {
-- 					threads = 0;
-- 				},
-- 				clang = {
-- 					excludeArgs = { "-frounding-math"} ;
-- 					resourceDir = "/usr/lib/llvm-7/lib/clang/7.0.1/include" ;
-- 				},
-- 				cache = {
-- 					directory = cclscachepath 
-- 				},
--     },
--     cmd = { 
-- 			'ccls',  
-- 			'--log-file=/tmp/ccls.log',
-- 			'-v=1'
--     },
--     -- root_dir = require('lspconfig/util').root_pattern("compile_commands.json", "compile_flags.txt", ".ccls"),
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     }
--   --filetypes = { "c", "cpp", "objc", "objcpp" } ;
-- 	--capabilities = capabilities ;
-- 	--root_dir = vim.loop.cwd ;
-- 	--root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".ccls") or '/home/ACM-Lab/.Test' ;
-- 	--root_dir = {'echo', 'getcwd()'} ;
--   -- "--log-file=/tmp/ccls.log -v=1"
-- }

--##########################################################################################################
-- Null-ls config------------------------------------------
--###################################################################################################################

-- local null_ls = require("null-ls")
-- local null_sources = {
-- 		null_ls.builtins.formatting.stylua.with({
-- 			filetypes = { "lua"},
-- 		}),
--     -- null_ls.builtins.formatting.prettier,
--     -- null_ls.builtins.diagnostics.write_good,
--     -- null_ls.builtins.code_actions.gitsigns,
-- }
-- null_ls.setup({
--     -- you must define at least one source for the plugin to work
--     sources = null_sources,
-- })

