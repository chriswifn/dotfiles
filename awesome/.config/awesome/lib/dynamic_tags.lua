-- library to declutter dynamic tagging in rc.lua
-- provides some wrapper functions on creating, deleting, renaming tags
-- author: Christian Hageloch



---- LIBRARIES
local awful = require("awful")



local M = {}



---- FIND TAG BY NAME

-- returns true if the given tag (tag_name) exists in the taglist of the provided screen
-- (screen)
-- helper function to provide necessary information on whether to create
-- a tag or perform an action on an already existing tag
local function find_tag_by_name(tag_name, screen)
    local tags = screen and screen.tags or root.tags()
    for _, t in ipairs(tags) do
        if string.find(t.name, tag_name) then
            return t
        end
    end
end



---- ADD TAG HELPER

-- add a tag with name (tag_name), index in the taglist (index) on the given screen (screen)
-- with tiling algorithm (layout)
-- volatile tells the tag attribute to delete itself, when the last client is closed
local function add_tag_helper(tag_name, index, screen, layout, volatile)
    return awful.tag.add(
	tag_name,
	{
	    screen = screen,
	    index = index,
	    layout = layout,
	    volatile = volatile,
	}
    )
end



---- ADD TAG

-- provided a given tag_name add_tag creates the tag (tag_name) if it doesn't already exists
-- in the taglist of the given screen (screen).
-- otherwise it will focus the provided tag
function M.add_tag(tag_name, index, screen, layout, volatile)
    if not tag_name or #tag_name == 0 then return end
    local tag = find_tag_by_name(tag_name, screen)

    if not tag then
	tag = add_tag_helper(tag_name, index, screen, layout, volatile)
    end
    tag:view_only()
end



---- SHIFT FOCUSED CLIENT TO TAG

-- shift_to_tag is used to shift a client (client) to a tag (tag_name) if
-- the tag exists in the taglist of the given screen (screen).
-- otherwise it will create the tag first and then shift the client to
-- the new tag
function M.shift_to_tag(client, tag_name, index, screen, layout, volatile)
    if not tag_name or #tag_name == 0 then return end

    if client then
	local tag = find_tag_by_name(tag_name, screen)
	if not tag then
	    tag = add_tag_helper(tag_name, index, screen, layout, volatile)
	end
	client:move_to_tag(tag)
	tag:view_only()
    end
end



---- VIEWTOGGLE TAG

-- toggle the visibility of a tag (tag_name) on the given screen (screen)
function M.viewtoggle(tag_name, screen)
    local tag = find_tag_by_name(screen, tag_name)
    if tag then
	awful.tag.viewtoggle(tag)
    end
end



--- TOGGLE TAG

-- toggle the visibility of a client (client) on a given tag (tag_name).
-- if the tag doesn't already exists toggle_tag will create it first and
-- then toggle the visibility
function M.toggle_tag(client, tag_name, index, screen, layout, volatile)
    if client then
	local tag = find_tag_by_name(tag_name, screen)
	if not tag then
	    tag = add_tag_helper(tag_name, index,screen,layout, volatile)
	end
	client:toggle_tag(tag)
    end
end



---- RENAME TAG

-- rename the given tag (tag_name) to another name
-- format: old_name [new_name]
function M.rename_tag(tag_name)
    if not tag_name or #tag_name == 0 then return end

    local tag = awful.screen.focused().selected_tag
    if tag then
	tag.name = tag.name .. " [" .. tag_name .. "]"
    end
end



---- DELETE TAG

-- delete the currently focused tag
function M.delete_tag()
    local tag = awful.screen.focused().selected_tag
    if not tag then return end
    tag:delete()
end



return M
