local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- no auto comment on new line
autocmd('BufEnter', {
	pattern = '*',
	command = 'set fo-=c fo-=r fo-=o'
})

-- set ident
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
  'yaml', 'lua'
},
command = 'setlocal shiftwidth=2 tabstop=2'
})
