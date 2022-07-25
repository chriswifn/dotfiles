-- function for mappings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- map leader to <Space>
vim.g.mapleader = ' '

-- general
map('n', '<leader><esc>', ':nohlsearch<CR>')
map('n', '<leader>p', ':lcd %:p:h<CR>')
map('t', '<Esc>', '<C-\\><C-n>')

-- splits
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-Left>', ':vertical resize -3<CR>')
map('n', '<C-Right>', ':vertical resize +3<CR>')
map('n', '<C-Up>', ':resize -3<CR>')
map('n', '<C-Down>', ':resize +3<CR>')

-- Telescope
map('n', '<leader>ff', ':Telescope find_files hidden=true<CR>')
map('n', '<leader>fr', ':Telescope oldfiles<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fb', ':Telescope buffers<CR>')
map('n', '<leader>ld', ':Telescope diagnostics<CR>')
map('n', '<leader>fe', ':Telescope file_browser<CR>')

-- buffers
map('n', '<leader>bn', ':bNext<CR>')
map('n', '<leader>bp', ':bprevious<CR>')
map('n', '<leader>bk', ':bdelete<CR>')
