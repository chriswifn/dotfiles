local modules = {
  'impatient',
  'plugins',
  'core/autocmds',
  'core/options',
  'core/keymaps',
  'core/colors',
  'configs/lspconfig',
  'configs/cmp',
  'configs/treesitter',
  'configs/telescope',
  'configs/expressline',
}

for k, v in pairs(modules) do
  package.loaded[v] = nil
  require(v)
end
