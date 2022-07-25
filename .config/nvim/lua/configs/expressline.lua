local status_ok, lualine = pcall(require, 'el')
if not status_ok then
  return
end

require('el').setup { generator = default }

