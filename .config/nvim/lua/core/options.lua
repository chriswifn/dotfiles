local g = vim.g
local opt = vim.opt

-- general
opt.clipboard = 'unnamedplus'
opt.swapfile = false
opt.completeopt = 'menuone,noinsert,noselect'
opt.ignorecase = true
opt.splitbelow = true
-- opt.guicursor = ""
opt.hidden = true
opt.wrap = false 
opt.scrolloff = 8
opt.laststatus = 3
vim.wo.fillchars = 'eob: '

-- ui
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.syntax = "ON"
opt.termguicolors = true

-- tabs
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
