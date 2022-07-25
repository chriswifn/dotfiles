local status_ok, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	return
end

nvim_treesitter.setup {
	-- things that I use 
	ensure_installed = {
		'bash', 'c', 'cpp', 'css', 'html', 'javascript', 'json', 'lua', 'python',
		'typescript', 'vim', 'php'
	},
	sync_install = false,
	highlight = {
		enable = true,
    additional_vim_regex_highlighting = true,
	},
  autotag = {
    enable = true,
    filetypes = { "html", "xml", "javascript", "python", "php" }
  }
}
