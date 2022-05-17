function Mapear(mode, key, action)
	vim.api.nvim_set_keymap(mode, key, action, {
		noremap = true,
		silent = true
	})
end

-- Leader key: SPACE
vim.g.mapleader = ' '
-- Telescope 
Mapear('n', '<leader>ff', ':Telescope find_files<cr>')
-- Tree 
Mapear('n', '<leader>e', ':NvimTreeToggle<cr>')
-- COC 
Mapear('i', '<TAB>', '<C-n>')
Mapear('n', 'gd', '<Plug>(coc-definition)') -- <C-o> to go back
