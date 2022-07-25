local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

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

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ 
  "unclutter --root", 
  "lxpolkit", 
  "setxkbmap -option caps:escape",
  "wmname LG3D",
  "/usr/bin/emacs --daemon",
})

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
emacs = "emacsclient -c -a 'emacs'"

modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}

mytextclock = wibox.widget.textclock("[%a %b %d, %H:%M]")

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local function set_wallpaper(s)
    -- if beautiful.wallpaper then
    --     local wallpaper = beautiful.wallpaper
    --     -- If wallpaper is a function, call it with the screen
    --     if type(wallpaper) == "function" then
    --         wallpaper = wallpaper(s)
    --     end
    --     gears.wallpaper.maximized(wallpaper, s, true)
    -- end
    gears.wallpaper.set("#000000")
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    awful.tag({ 
      " [1:WWW] ", 
      " [2:TERM] ", 
      " [3:SYS] ", 
      " [4:SYS] ", 
      " [5:NVIM] ",
      " [6:DOC] ", " [7:MUS] ",
      " [8:VID] ",
      " [9:NULL] " 
    }, s, awful.layout.layouts[1])
    s.mypromptbox = awful.widget.prompt()

    s.systray = wibox.widget.systray()
    s.systray.visible = false

    s.internet = awful.widget.watch("sb-internet", 1)
    s.internet.visible = false
    s.battery = awful.widget.watch("sb-battery", 1000)
    s.battery.visible = false

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        -- filter  = awful.widget.taglist.filter.all,
        -- style = {
        --   spacing = 6,
        -- },
        buttons = taglist_buttons,
    }
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        -- filter  = awful.widget.tasklist.filter.currenttags,
        filter  = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
        style = {
          tasklist_disable_icon = true,
        },
    }
    s.mywibox = awful.wibar({ position = "top", screen = s, height=24})
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            s.internet,
            s.battery,
            mytextclock,
            s.systray,
        },
    }
end)

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "=",     function ()
        awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
      end, {description = "Toggle systray visibility", group = "custom"}
      ),
    awful.key({ modkey,           }, "i",     function ()
        awful.screen.focused().battery.visible = not awful.screen.focused().battery.visible
      end, {description = "Toggle battery visibility", group = "custom"}
      ),
    awful.key({ modkey,           }, "w",     function ()
        awful.screen.focused().internet.visible = not awful.screen.focused().internet.visible
      end, {description = "Toggle internet visibility", group = "custom"}
      ),

    awful.key( {modkey}, "p", function()
      local grabber
      grabber =
      awful.keygrabber.run(
      function(_, key, event)
        if event == "release" then return end

        if     key == "a" then awful.spawn.with_shell("dmenu_run")
        elseif key == "m" then awful.spawn.with_shell("monitors")
        elseif key == "b" then awful.spawn.with_shell("bookmarks")
        elseif key == "k" then awful.spawn.with_shell("keyboard")
        elseif key == "s" then awful.spawn.with_shell("maimmenu")
        elseif key == "i" then awful.spawn.with_shell("network")
        elseif key == "l" then awful.spawn.with_shell("logoutmenu")
        elseif key == "p" then awful.spawn.with_shell("passmen")
        elseif key == "w" then awful.spawn.with_shell("connectwifi")
        elseif key == "e" then awful.spawn.with_shell("emojipicker")
        elseif key == "v" then awful.spawn.with_shell("vid")
        end
        awful.keygrabber.stop(grabber)
      end
      )
    end,
    {description = "followed by KEY", group = "Scripts"}
    ),

    awful.key( {modkey}, "t", function()
      local grabber
      grabber =
      awful.keygrabber.run(
      function(_, key, event)
        if event == "release" then return end

        if     key == "t" then awful.spawn.with_shell("st -e tmux")
        elseif key == "h" then awful.spawn.with_shell("st -e htop")
        elseif key == "a" then awful.spawn.with_shell("st -e cmus")
        elseif key == "r" then awful.spawn.with_shell("st -e lf_run")
        elseif key == "p" then awful.spawn.with_shell("st -e pulsemixer")
        elseif key == "v" then awful.spawn.with_shell("st -e alsamixer")
        end
        awful.keygrabber.stop(grabber)
      end
      )
    end,
    {description = "followed by KEY", group = "Terminal apps"}
    ),

    awful.key( {modkey}, "e", function()
      awful.spawn(emacs)
    end,
    {description = "Emacs", group = "custom"}),

    awful.key( {modkey,}, "g", function() 
      awful.spawn( "firefox -no-default-browser-check" )
    end,
    {description = "firefox", group = "custom"}),

    awful.key( {modkey,}, "z", function()
      awful.spawn( "zathura" )
    end,
    {description = "zathura", group = "custom"}),

    awful.key( {modkey, "Shift"}, "f", function()
      awful.spawn( "pcmanfm" )
    end,
    {description = "pcmanfm", group = "custom"}),

    awful.key( {modkey, "Shift"}, "s", function()
      awful.spawn( "slock" )
    end,
    {description = "slock", group = "custom"}),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey }, "b",
        function ()
          for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
              s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
          end
        end,
        {description = "toggle wibox", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    awful.key({ modkey, "Shift" }, "Return", function () awful.util.spawn("dmenu_run") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, "Shift" },   "y", awful.placement.centered),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

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

root.keys(globalkeys)

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
                     size_hints_honor = false
     }
    },

    { rule_any = {
        instance = {
          "copyq",
        },
        class = {
          "Sxiv",
          "Tor Browser",
        },

        name = {
          "bash",
          "Save File"
        },
        role = {
          "pop-up",
        }
      }, properties = { floating = true, placement = "centered" }},

    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
}

function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
