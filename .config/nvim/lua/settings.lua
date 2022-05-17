vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = "ON"
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.opt.autoindent = true

vim.g.t_Co = 256
vim.opt.clipboard = "unnamedplus"

-- plugins
require('nvim-autopairs').setup()
require('Comment').setup()
require('lualine').setup()
require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "html", "css", "python", "javascript", "php"},
        sync_intall = false,
        highlight = {
                enable = true,
                additional_vim_regex_hightlighting = false,
        }
}
require'colorizer'.setup()
