---- LIBRARIES

-- standard awesome library
local gears = require("gears")
local awful = require("awful")

-- autofocus
require("awful.autofocus")

-- notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local nconf = naughty.config
nconf.defaults.position = "top_middle"

-- theme handling library
local beautiful = require("beautiful")

-- widget and layout library
local wibox = require("wibox")

-- dynamic tags
local dynamic_tags = require("lib.dynamic_tags")




---- ERROR HANDLING

-- check if awesome encountered an error during startup and fall back to another config
-- (this code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
		     title = "Oops, there were errors during startup!",
		     text = awesome.startup_errors })
end

-- handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
			       -- Make sure we don't go into an endless error loop
			       if in_error then return end
			       in_error = true

			       naughty.notify({ preset = naughty.config.presets.critical,
						title = "Oops, an error happened!",
						text = tostring(err) })
			       in_error = false
    end)
end



---- GARBAGE COLLECTION
collectgarbage("setpause", 160)
collectgarbage("setstepmul", 400)

gears.timer.start_new(
    10,
    function()
	collectgarbage("step", 20000)
	return true
    end
)



---- VARIABLES

-- variables to change programs easily
local terminal = "st "
local editor = "emacsclient -c -a 'emacs' "
local browser = "firefox"

-- default modkey
modkey = "Mod4"



---- WALLPAPER

-- black screen is enough
local function set_wallpaper(s)
    gears.wallpaper.set("#000000")
end

-- re-set the wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)



---- THEME

-- load the theme based on a theme file that is controled by the script 'delight'

local handle = assert(io.open(
			  string.format("%s/.config/awesome/theme/active-theme",
					os.getenv("HOME"))))
local active_theme = string.gsub(assert(handle:read("*a")), "\n", "")
handle:close()

local theme = beautiful.init(string.format("%s/.config/awesome/theme/".. active_theme .. "/theme.lua", os.getenv("HOME")))



---- LAYOUTS

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
}



---- FUNCTIONS TO RUN FOR EVERY SCREEN (set tags, configure wibar)

awful.screen.connect_for_each_screen(function(s)
	-- set the wallpaper
	set_wallpaper(s)

	-- tag declaration (only one tag, because they are going to be defined dynamically)
	awful.tag({"1"},
	    s,
	    {awful.layout.layouts[1]})

	-- prompt: to change the name of a tag
	s.mypromptbox = awful.widget.prompt()

	-- systray: sometimes a systray is useful
	-- is toggled of by default, see below for keybinding to toggle on
	s.systray = wibox.widget.systray()
	s.systray.visible = false

	-- print a list of all tags on every wibar 
	s.mytaglist = awful.widget.taglist {
	    screen = s,
	    filter  = awful.widget.taglist.filter.all,
	}

	-- window title in the wibar
	s.mytasklist = awful.widget.tasklist {
	    screen  = s,
	    filter  = awful.widget.tasklist.filter.currenttags,
	}

	s.mylayoutbox = awful.widget.layoutbox(s)

	-- configure wibar to be on top and appear on every screen
	s.mywibox = awful.wibar({ position = "top", screen = s })

	s.mywibox:setup {
	    layout = wibox.layout.align.horizontal,
	    { -- Left widgets
		layout = wibox.layout.fixed.horizontal,
		s.mypromptbox,
		s.mytaglist,
	    },
	    -- middle widget
	    s.mytasklist,
	    { -- right widgets
		layout = wibox.layout.fixed.horizontal,
		s.systray,
		s.mylayoutbox,
	    },
	}
end)



---- KEYBINDINGS

-- these keybindings only include keybindings that I use
-- the other ones are removed so that they don't trigger by accident

--- DEFAULT KEYS (kindof)
globalkeys = gears.table.join(

    -- terminal
    awful.key({ modkey }, "Return",
    function()
        awful.spawn(terminal)
    end,
	{description = "spawn terminal", group = "terminal"}
    ),

    -- focus down the stack
    awful.key({ modkey }, "j",
	function ()
	    awful.client.focus.byidx( 1)
	end,
	{description = "focus next by index", group = "client"}
    ),

    -- focus up the stack
    awful.key({ modkey }, "k",
	function ()
	    awful.client.focus.byidx(-1)
	end,
	{description = "focus previous by index", group = "client"}
    ),

    -- enlarge master
    awful.key({ modkey }, "l",
	function ()
	    awful.tag.incmwfact( 0.05)
	end,
	{description = "increase master width factor", group = "layout"}),

    -- shrink master
    awful.key({ modkey }, "h",
	function ()
	    awful.tag.incmwfact(-0.05)
	end,
	{description = "decrease master width factor", group = "layout"}),

    -- swap
    awful.key({ modkey, "Shift" }, "j",
	function ()
	    awful.client.swap.byidx(  1)
	end,
	{description = "swap with next client by index", group = "client"}),

    -- swap
    awful.key({ modkey, "Shift" }, "k",
	function ()
	    awful.client.swap.byidx( -1)
	end,
	{description = "swap with previous client by index", group = "client"}),

    -- monitor
    awful.key({ modkey, "Control" }, "j",
	function ()
	    awful.screen.focus_relative( 1)
	end,
	{description = "focus the next screen", group = "screen"}),

    -- monitor
    awful.key({ modkey, "Control" }, "k",
	function ()
	    awful.screen.focus_relative(-1)
	end,
	{description = "focus the previous screen", group = "screen"}),

    -- increase the number of master clients
    awful.key({ modkey, "Shift" }, "h",
	function ()
	    awful.tag.incnmaster( 1, nil, true)
	end,
	{description = "increase the number of master clients", group = "layout"}),

    -- decrease the number of master clients
    awful.key({ modkey, "Shift" }, "l",
	function ()
	    awful.tag.incnmaster(-1, nil, true)
	end,
	{description = "decrease the number of master clients", group = "layout"}),

    -- select next layout
    awful.key({ modkey }, "space",
	function ()
	    awful.layout.inc( 1)
	end,
	{description = "select next", group = "layout"}),

    -- select previous layout
    awful.key({ modkey, "Shift" }, "space",
	function ()
	    awful.layout.inc(-1)
	end,
	{description = "select previous", group = "layout"}),

    awful.key({ modkey }, "x",
	function()
	    local grabber
	    grabber =
		awful.keygrabber.run(
		    function(_, key, event)
			if event == "release" then return end

			if key == "r" then
			    awesome.restart()

			elseif key == "q" then
			    awesome.quit()

			elseif key == "p" then
			    awful.util.spawn("rofi -show run")

			elseif key == "l" then
			    awful.util.spawn("slock")
			end
			awful.keygrabber.stop(grabber)
		    end
		)
	end,
	{description = "awesome keys", group = "awesome"}
    )
)

--- DMENU KEYS
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey }, "d", function()
	    local grabber
	    grabber =
		awful.keygrabber.run(
		    function(_, key, event)
			if event == "release" then return end
			if key == "a" then awful.spawn.with_shell("rofi -show drun")
			elseif key == "b" then awful.spawn.with_shell("prompt_bookmarks")
			elseif key == "k" then awful.spawn.with_shell("keyboard")
			elseif key == "s" then awful.spawn.with_shell("prompt_screenshot")
			elseif key == "i" then awful.spawn.with_shell("prompt_managewifi")
			elseif key == "l" then awful.spawn.with_shell("prompt_logout")
			elseif key == "p" then awful.spawn.with_shell("passmenu -l 10 -p 'Choose password: '")
			elseif key == "t" then awful.spawn.with_shell("awesome_theme")
			elseif key == "f" then awful.spawn.with_shell("prompt_firefoxmanage")
			elseif key == "w" then awful.spawn.with_shell("rofi -show window")
			end
			awful.keygrabber.stop(grabber)
		    end
		)
    end,
	{description = "dmenu keys", group = "dmenu"}
    )
)

--- WIBAR/TAG KEYS
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey }, "w", function()
	    local grabber
	    grabber =
		awful.keygrabber.run(
		    function(_, key, event)
			if event == "release" then return end
			if key == "b" then
			    for s in screen do
				s.mywibox.visible = not s.mywibox.visible
			    end
			elseif key == "s" then 
			    awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
			end
			awful.keygrabber.stop(grabber)
		    end
		)
    end,
	{description = "wibar keys", group = "wibar"}
    )
)

--- TAG KEYS
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey }, "b", function()
	    local grabber
	    grabber =
		awful.keygrabber.run(
		    function(_, key, event)
			if event == "release" then return end

			-- add a tag or switch to existing one
			if key == "a" then
			    awful.prompt.run {
				prompt = "Create new tag: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(tag_name)
				    dynamic_tags.add_tag(
					tag_name,
					nil,
					awful.screen.focused(),
					awful.layout.suit.tile,
					true
				    )
				end
			    }

			-- shift focused client to new tag or existing one
			elseif key == "s" then
			    awful.prompt.run {
				prompt = "Shift client to tag: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(tag_name)
				    local c = client.focus
				    dynamic_tags.shift_to_tag(
					c,
					tag_name,
					nil,
					c.screen,
					awful.layout.suit.tile,
					true
				    )
				end
			    }

		        -- rename tag
			elseif key == "r" then
			    awful.prompt.run {
				prompt       = "New tag name: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(tag_name)
				    dynamic_tags.rename_tag(tag_name)
				end
			    }

			elseif key == "d" then
			    dynamic_tags.delete_tag()
			end
			awful.keygrabber.stop(grabber)
		    end
		)
    end,
	{description = "tag keys", group = "tag"}

    )
)

--- PROGRAM KEYS
globalkeys = gears.table.join(
    globalkeys,
    awful.key( {modkey}, "g", function()
	    local grabber
	    grabber =
		awful.keygrabber.run(
		    function(_, key, event)
			if event == "release" then return end
			if key == "g" then
			    local matcher = function(c)
				return awful.rules.match(c, {class = "firefox"})
			    end
			    awful.client.run_or_raise(browser, matcher)
            elseif key == "e" then
			    local matcher = function(c)
                    return awful.rules.match(c, {class = "Emacs"})
                end
                awful.client.run_or_raise(editor, matcher)
            elseif key == "t" then
			    local matcher = function(c)
				return awful.rules.match(c, { class = "st-256color" })
			    end
			    awful.client.run_or_raise(terminal .. "-e tmux new-session -A -s tempterm", matcher)
			elseif key == "z" then awful.spawn.raise_or_spawn("zathura", {class = "zathura"})
			elseif key == "f" then awful.spawn.raise_or_spawn("pcmanfm", {class = "pcmanfm"})
			elseif key == "v" then awful.spawn.raise_or_spawn("virt-manager", {class = "Virt-manager"}) 
			elseif key == "s" then awful.spawn.with_shell("slock")
			end
			awful.keygrabber.stop(grabber)
		    end
		)
    end,
	{description = "gui keys", group = "gui"}
    )
)

--- CLIENTKEYS

local function myclient(c)
    local grabber
    grabber = awful.keygrabber.run(
	function(mod, key, event)
	    if event == "release" then return end

	    if key == "c" then -- kill a client
		c:kill()

	    elseif key == "f" then
		c.fullscreen = not c.fullscreen
		c:raise()

	    elseif key == "t" then -- toggle floating
		awful.client.floating.toggle()

	    elseif key == "Return" then -- promote to master
		c:swap(awful.client.getmaster())

	    elseif key == "o" then -- move to other screen
		c:move_to_screen()

	    elseif key == "g" then -- go to the center
		awful.placement.centered()

	    elseif key == "s" then -- sticky
		c.sticky = not c.sticky

	    elseif key == "u" then -- jump to urgent tag
		awful.client.urgent.jumpto()

	    end
	    awful.keygrabber.stop(grabber)
    end)
end

clientkeys = gears.table.join(
    awful.key( {modkey}, "c", myclient,
	{description = "client keys", group = "client"})
)

--- TAGKEYS

-- function to find tag by name.
-- the default awful.tag.find_tag_by_name only compares two strings on equality.
-- this one test if the supplied tagname (name) is contained in an existing tagname
function find_tag_by_name(s, name)
    -- TODO: maybe implement this into core, because the default way doesn't make much sense.
    local tags = s and s.tags or root.tags()
    for _, t in ipairs(tags) do
        if string.find(t.name, name) then
            return t
        end
    end
end

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
				  awful.key({ modkey }, "#" .. i + 9,
				      function ()
					  dynamic_tags.add_tag(
					      tostring(i),
					      tonumber(i),
					      awful.screen.focused(),
					      awful.layout.suit.tile,
					      true
					  )
				      end,
				      {description = "view tag #"..i, group = "tag"}),
				  awful.key({ modkey, "Control" }, "#" .. i + 9,
				      function ()
					  dynamic_tags.viewtoggle(
					      awful.screen.focused(),
					      tostring(i)
					  )
				      end,
				      {description = "toggle tag #" .. i, group = "tag"}),
				  awful.key({ modkey, "Shift" }, "#" .. i + 9,
				      function ()
					  local client = client.focus
					  dynamic_tags.shift_to_tag(
					      client,
					      tostring(i),
					      tonumber(i),
					      client.screen,
					      awful.layout.suit.tile,
					      true
					  )
				      end,
				      {description = "move focused client to tag #"..i, group = "tag"}),
				  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				      function ()
					  local client = client.focus
					  dynamic_tags.toggle_tag(
					      client,
					      tostring(i),
					      tonumber(i),
					      client.screen,
					      awful.layout.suit.tile,
					      true
					  )
				      end,
				      {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

root.keys(globalkeys)



---- BUTTONS

--- CLIENT-BUTTONS

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
	    c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
	    c:emit_signal("request::activate", "mouse_click", {raise = true})
	    awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
	    c:emit_signal("request::activate", "mouse_click", {raise = true})
	    awful.mouse.client.resize(c)
    end)
)



---- RULES
 
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
		     border_color = beautiful.border_normal,
		     focus = awful.client.focus.filter,
		     raise = true,
		     keys = clientkeys,
		     buttons = clientbuttons,
		     screen = awful.screen.preferred,
		     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
		     size_hints_honor = false,
		     swallow = true
      }
    },

    { rule_any = {
	  instance = {
	      "copyq",
	  },
	  class = {
	      "Sxiv",
	      "Tor Browser",
	      "MATLAB R2022b - academic use",
	  },
	  name = {
	      "bash",
	      "Save File"
	  },
	  role = {
	      "pop-up",
	  }
    }, properties = { floating = true, placement = "centered", tag = false}},

    { rule = { class = "zoom" },
      properties = { new_tag = true },
    },

    { rule = { class = "MATLAB R2022b - academic use" },
      properties = { new_tag = true },
    },

    { rule_any = {type = { "normal", "dialog" }
		 }, properties = { titlebars_enabled = false }
    },
}



--- AUTOSTART

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
	awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- programs that should autostart
run_once({
	-- nobody needs caps lock 
	"setxkbmap -option caps:escape",
	-- xresources
	"xrdb -merge $HOME/.config/x11/xresources",
	-- to fix java bugs in applications
	"wmname LG3D",
	-- monitor configuration
	"xorg_automonitor",
})



---- SIGNALS

-- signal function to execute when a new client appears
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- theming signals
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
