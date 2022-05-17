vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = "ON"

vim.opt.autoindent = true

vim.g.t_Co = 256
vim.opt.clipboard = "unnamedplus"

-- plugins
require('nvim-autopairs').setup()
require('Comment').setup()
require('lualine').setup()
