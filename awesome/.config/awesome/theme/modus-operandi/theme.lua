--------------------------------------------------
-- modus vivendi theme (originally an emacs theme)
--------------------------------------------------

--  some imports that are necessary
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local configuration_path = gfs.get_configuration_dir()

-- generate table for options
local theme = {}

-- font
theme.font = "Monoid 9"
theme.tasklist_disable_icon = true

-- background colors
theme.bg_normal     = "#e6e6e6"
theme.bg_focus      = "#bfbfbf"
theme.bg_urgent     = "#a60000"
theme.bg_minimize   = "#595959"
theme.bg_systray    = theme.bg_normal

-- foreground colors
theme.fg_normal     = "#000000"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- gaps and border options
theme.useless_gap   = dpi(0)
theme.gap_single_client =  false
theme.border_width  = dpi(2)
theme.border_normal = "#ffffff"
theme.border_focus  = "#721045"
theme.border_marked = "#a60000"

-- taglist
theme.taglist_spacing = 2
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
  taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
  taglist_square_size, theme.fg_normal
)

-- no stupid icons
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
