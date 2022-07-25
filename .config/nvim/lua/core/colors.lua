require("gruvbox").setup({
  italic = false,
  contrast = "hard",
  overrides = {
    StatusLine = {fg = "#282828"},
    StatusLineNC = {fg = "#282828"},
  },
})
vim.cmd([[autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE]])
vim.cmd([[colorscheme gruvbox]])
