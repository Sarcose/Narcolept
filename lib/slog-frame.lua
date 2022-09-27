local m = {
  debug        = false,
  _NAME        = 'SYSL Slice Nine',
  _VERSION     = '0.2',
  _DESCRIPTION = 'A frame slicer and drawer',
  _URL         = 'https://github.com/SystemLogoff/SLog-Library',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2019 Chris / Systemlogoff

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

--[[--------------------------------------------------------------------------------------------------------------------
 * Global -> Local 
--------------------------------------------------------------------------------------------------------------------]]--
-- Read more: http://lua-users.org/wiki/OptimisingUsingLocalVariables
local print = print
local love = love 
local math = math

--[[--------------------------------------------------------------------------------------------------------------------
 * Internal Values
--------------------------------------------------------------------------------------------------------------------]]--
local texture_container
local folder_frames
-- Table that holds the generated frames.
m.select = {}

--[[--------------------------------------------------------------------------------------------------------------------
 * Local Functions
--------------------------------------------------------------------------------------------------------------------]]--
local function dprint(...)
    if m.debug then
        print(m._NAME .. ": ", unpack({...}))
    end
end

dprint("Loaded")

-- Splits a string into parts by a single character.
-- Inputs, String <String>, Single Character <String> to split
local function stringSplitSingle(str,sep)
    local return_string={}
    local n=1
    for w in str:gmatch("([^"..sep.."]*)") do
        return_string[n] = return_string[n] or w -- only set once (so the blank after a string is ignored)
        if w=="" then
            n = n + 1
        end -- step forwards on a blank but not a string
    end
    return return_string
end

--[[--------------------------------------------------------------------------------------------------------------------
 * Instantiation addon	-- _G replaced with self.textures.frames and _G related errors commented out
--------------------------------------------------------------------------------------------------------------------]]--

m.textures = {}
m.textures.frames = {}

function m:new(t) 	--create a table of preloaded frames and pass with newframe = frame:new(frames)
	local r = deepcopy(self,'slogframes')
	
	r.textures.frames = t
	r:load()

	return r
end



--[[--------------------------------------------------------------------------------------------------------------------
 * Setup on Import
--------------------------------------------------------------------------------------------------------------------]]--
function m:load()
    --assert(import_texture_container and import_folder_frames, "The global container for textures, the sub-table that texture/frames is stored in are required.")
    --texture_container, folder_frames = import_texture_container, import_folder_frames
	for i,v in pairs(self.textures.frames) do
        local temptable = {}
        temptable = stringSplitSingle(i,"_")
        if #temptable == 2 then
			temptable[2] = tonumber(temptable[2])
            self:create(
                temptable[1], 
                i,
                temptable[2],
                temptable[2],
                temptable[2],
                temptable[2],
                temptable[2],
                temptable[2]
            )
        elseif #temptable == 7 then
            self:create(
                temptable[1], 
                i, 
                tonumber(temptable[2]),
                tonumber(temptable[3]),
                tonumber(temptable[4]),
                tonumber(temptable[5]),
                tonumber(temptable[6]),
                tonumber(temptable[7])
            )
        else
            assert(false, "Error: Frame name does not match format. Name_Size, or Name_Size1_Size2_...Size_6")
        end
	end
end

--[[ Notes ]]-------------------------------------------------------------------
-- Slice a frame
function m:create(name, imagename, size, size2, size3, size4, size5, size6)
    local image_width = size + size2 + size3
    local image_height = size4 + size5 + size6
    self.select[name] = {
    ["image"] = imagename,
    ["sizes"] = {size,size2,size3,size4,size5,size6}, -- X Width 1, 2, 3 Row, Y same Col
    ["top_left"] =        love.graphics.newQuad(0,                 0,                   size, size4, image_width, image_height),
    ["top_middle"] =      love.graphics.newQuad(0 + size,          0,                   size2, size4, image_width, image_height),
    ["top_right"] =       love.graphics.newQuad(0 + size + size2,  0,                   size3, size4, image_width, image_height),
    ["middle_left"] =     love.graphics.newQuad(0,                 0 + size4,           size, size5, image_width, image_height),
    ["middle_middle"] =   love.graphics.newQuad(0 + size,          0 + size4,           size2, size5, image_width, image_height),
    ["middle_right"] =    love.graphics.newQuad(0 + size + size2,  0 + size4,           size3, size5, image_width, image_height),
    ["bottom_left"] =     love.graphics.newQuad(0,                 0 + size4 + size5,   size, size6, image_width, image_height),
    ["bottom_middle"] =   love.graphics.newQuad(0 + size,          0 + size4 + size5,   size2, size6, image_width, image_height),
    ["bottom_right"] =    love.graphics.newQuad(0 + size + size2,  0 + size4 + size5,   size3, size6, image_width, image_height),
    }
end

--[[ Notes ]]-------------------------------------------------------------------
-- Draw a frame with the middle stretched out.
function m:draw(name,x,y,w,h)
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)
    local frame_library = self.textures.frames
    local frame_data = self.select[name]
    assert(frame_data, "Frame chosen must exist in self.textures.frames either through frame:new() or frame:add()!")
    local frame_selected = frame_library[frame_data.image]
    local width_center = (w - frame_data.sizes[1] - frame_data.sizes[3]) / frame_data.sizes[2]
    local height_center = (h - frame_data.sizes[4] - frame_data.sizes[6]) / frame_data.sizes[5]
    local padding = {
        top = frame_data.sizes[4], 
        right = frame_data.sizes[3], 
        bottom = frame_data.sizes[6], 
        left = frame_data.sizes[1]
    }

    -- Middle - Top
    love.graphics.draw(frame_selected, frame_data["top_middle"], x + padding.left, y, 0, width_center, 1)
    -- Middle - Right
    love.graphics.draw(frame_selected, frame_data["middle_right"], x + w - padding.right, y + padding.top, 0, 1, height_center)
    -- Middle - Bottom
    love.graphics.draw(frame_selected, frame_data["bottom_middle"], x + padding.left, y + h - padding.bottom, 0, width_center, 1)
    -- Middle - Left
    love.graphics.draw(frame_selected, frame_data["middle_left"], x, y + padding.top, 0, 1, height_center)
    -- Corners
    love.graphics.draw(frame_selected, frame_data["top_left"], x, y)
    love.graphics.draw(frame_selected, frame_data["top_right"], x + w - padding.right, y)
    love.graphics.draw(frame_selected, frame_data["bottom_left"], x, y + h - frame_data.sizes[6])
    love.graphics.draw(frame_selected, frame_data["bottom_right"], x + w - padding.right, y + h - padding.bottom)
    -- Center 
    love.graphics.draw(frame_selected, frame_data["middle_middle"], x + padding.left, y + padding.top, 0, width_center, height_center)
end

--[[ Notes ]]-------------------------------------------------------------------
-- Draw a frame with the parts tiled.
function m:draw_tiled(name,x,y,w,h,config)
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)
    local frame_library = self.textures.frames
    local frame_data = self.select[name]
    assert(frame_data, "Frame chosen must exist in " .. texture_container .. "/" .. folder_frames .. "!")
    local frame_selected = frame_library[frame_data.image]
    local width_center = (w - frame_data.sizes[1] - frame_data.sizes[3]) / frame_data.sizes[2]
    local height_center = (h - frame_data.sizes[4] - frame_data.sizes[6]) / frame_data.sizes[5]
    local padding = {
        top = frame_data.sizes[4], 
        right = frame_data.sizes[3], 
        bottom = frame_data.sizes[6], 
        left = frame_data.sizes[1]
    }
    config = config or {}

    -- Overflow tiles by one
    config.overflow = config.overflow or 1

    -- If we force things to stick to tile size, then we need to force the size.
    config.force_tile = config.force_tile or false
    if config.force_tile then 
        -- Overflow turns off
        config.overflow = 0
        local new_w = w
        local new_h = h

        -- Remove from width until it matches the tile sizes
        new_w = new_w - frame_data.sizes[1] - frame_data.sizes[3]
        while new_w > 0 do 
            new_w = new_w - frame_data.sizes[2]
        end
        new_w = new_w + frame_data.sizes[2]
        w = w - new_w

        -- Remove from height until it matches the tile sizes
        new_h = new_h - frame_data.sizes[4] - frame_data.sizes[6]
        while new_h > 0 do 
            new_h = new_h - frame_data.sizes[5]
        end
        new_h = new_h + frame_data.sizes[5]
        h = h - new_h
    end
    
    -- We always crop unless told not to.
    if config.crop == nil then config.crop = true end
    if config.crop then love.graphics.setScissor(x, y, math.max(w, 0), math.max(h, 0)) end

    -- Drawing Parts
    -- Center 
    if config.tile_center then
        for tile_x = 1, math.floor(width_center + 0.5) + config.overflow do 
            for tile_y = 1, math.floor(height_center + 0.5) + config.overflow do 
                love.graphics.draw(
                    frame_selected, 
                    frame_data["middle_middle"], 
                    x + padding.left + frame_data.sizes[2] * (tile_x-1), 
                    y + padding.top + frame_data.sizes[5] * (tile_y-1)
                )
            end
        end
    else 
        love.graphics.draw(frame_selected, frame_data["middle_middle"], x + padding.left, y + padding.top, 0, width_center, height_center)
    end
    -- Middle - Left/Righ
    for tile_y = 1, math.floor(height_center + 0.5) + config.overflow do 
        love.graphics.draw(frame_selected, frame_data["middle_left"], x, y + padding.top + frame_data.sizes[5] * (tile_y-1))
        love.graphics.draw(frame_selected, frame_data["middle_right"], x + w - padding.right, y + padding.top + frame_data.sizes[5] * (tile_y-1))
    end
    -- Middle - Top/Bottom
    for tile_x = 1, math.floor(height_center + 0.5) + config.overflow do 
        love.graphics.draw(frame_selected, frame_data["top_middle"], x + padding.left + frame_data.sizes[2] * (tile_x-1), y)
        love.graphics.draw(frame_selected, frame_data["bottom_middle"], x + padding.left + frame_data.sizes[2] * (tile_x-1), y + h - padding.bottom)
    end
    -- Corners
    love.graphics.draw(frame_selected, frame_data["top_left"], x, y)
    love.graphics.draw(frame_selected, frame_data["top_right"], x + w - padding.right, y)
    love.graphics.draw(frame_selected, frame_data["bottom_left"], x, y + h - frame_data.sizes[6])
    love.graphics.draw(frame_selected, frame_data["bottom_right"], x + w - padding.right, y + h - padding.bottom)
    -- End Drawing
    -- If cropping, stop
    if config.crop then love.graphics.setScissor() end
end
--[[ End Frames ]]--------------------------------------------------------------

return m