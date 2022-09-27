
--[[Comparison]]

function bigger(a,b)
	return (a > b) and a or b or 0
end
function smaller(a,b)
	return (a < b) and a or b or 0
end
function compareFloat(a,b)
	--print('comparing '..tostring(a)..' to '..tostring(b))
	return (tostring(a)==tostring(b))
end
function shuffle(t)
	local tbl = {}
	for i = 1, #t do
	  tbl[i] = t[i]
	end
	for i = #tbl, 2, -1 do
	  local j = math.random(i)
	  tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end
function isTable(t)
	return (type(t)=='table')
end
function isString(s)
	return (type(s)=='string')
end
function isNumber(n)
	return (type(n)=='number')
end
function isFunction(f)
	return (type(f)=='function')
end
	
function clamp(n,clampmin,clampmax)
	if n > clampmax then return clampmax elseif n < clampmin then return clampmin else return n end
end

--[[Various Maths]]

function dist(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

function speedByVector(x1,y1,x2,y2)
	local xspeed = (x1-x2)
	local yspeed = (y1-y2)
	
	return xspeed, yspeed
end

function stepToTarget(x1,y1,x2,y2,speed,dt)
	dt = dt or 1
	local dx,dy = x2-x1,y2-y1
	local dist = math.sqrt(dx*dx + dy*dy)
	local step = speed*dt
	if dist <= step then
		return x2,y2
	else
		local nx = dx/dist
		local ny = dy/dist
		return x1+nx*step,y1+ny*step
	end
end

function moveByVector(x,y,xv,yv,dist)
	return stepToTarget(x,y,x+xv*dist,y+yv*dist,dist)
end
--[[function math.angle(x1, y1, x2, y2)
    return math.deg(math.atan2(y2-y1, x2-x1))%360
end]]
function angleByPoints(x1,y1,x2,y2)
	return math.atan2(y2-y1, x2-x1)
end
function angleRadians(x1,y1,x2,y2)
	return math.atan2(y2 - y1, x2 - x1) * 180 / math.pi
end
function angleFromVector(x,y)
	return math.atan2(y,x)
end
function vectorFromAngle(a)
	return math.cos(a),math.sin(a)
end
local _angleDirections = {
	[-1] = {
		[-1] =225,
		[0] =180,
		[1] =135,
	},
	[0] = {
		[-1] =270,
		[0] =0,
		[1] =90,
	},
	[1] = {
		[-1] = 315,
		[0] =0,
		[1] =45,
	}

}
function angleByDirections(dir,vert,facingdir)
	assert(dir,'dir passed is '..tostring(dir))
	assert(vert,'vert passed is '..tostring(vert))
	if facingdir ~= 0 then facingdir = getsign(facingdir) end
	if dir == 0 and vert == 0 then
		assert(_angleDirections[facingdir],'facingdir == '..tostring(facingdir))
		assert(_angleDirections[facingdir][vert],'vert == '..tostring(vert))
		return _angleDirections[facingdir][vert]
	else	return _angleDirections[dir][vert]	
	end
end
function reverseColor(o)
	local r = {}
	r[1] = 0.5 + (0.5 - o[1])
	r[2] = 0.5 + (0.5 - o[2])
	r[3] = 0.5 + (0.5 - o[3])
	return r
end
function findThird(value,max)	--
	local first,second = max/3,max/3*2
	if value <= first then return 1
	elseif value <= second then return 2
	else return 3 end
end
function getPercent(value,max)
	return value/max*100
end

local sin,cos = math.sin,math.cos
local pi = math.pi
function sineMove(time, angle, amplitude, waveLen)
    return
		cos(angle) * time * waveLen + ((amplitude / 2) * sin(time) * sin(angle)), 
    	sin(angle) * time * waveLen - ((amplitude / 2) * sin(time) * cos(angle))
end
function sineVector(x,y,oX,oY,offset,time,angle,amplitude,wavelen)
	local vectorX,vectorY = vectorFromAngle(angle)
    local sinX,sinY = sineMove(time,angle,amplitude,wavelen)
    local goalX,goalY = oX+sinX-(offset*vectorX),oY+sinY-(offset*vectorY)
	return goalX-x,goalY-y
end

--[[ 
        ]]

function darkenColor(o,ratio)
	local r = {}
	ratio = ratio or 0.5
	r[1] = o[1]*ratio
	r[2] = o[1]*ratio
	r[3] = o[1]*ratio
	return r
end
function notZero(x,y)
	if math.abs(x)>=y then return x else return y end
end
function orZero(n)
	if n<0 then return 0 else return n end
end
function rsign()
	return math.random(0,1)*2-1
end
function boolSwitch(v)
	if v then return false else return true end
end
function getsign(v)
	if v >= 0 then return 1 else return -1 end
end
function getsignzero(v)
	if v > 0 then return 1 elseif v == 0 then return 0 else return -1 end
end
function randomPick(t)	--random{1,2,3,4,5}
	return t[math.random(1,#t)]
end
function weightedRandom (pool)
   local poolsize = 0
   for k,v in ipairs(pool) do
     poolsize = poolsize + v[1]
   end
   local selection = math.random(1,poolsize)
   for k,v in pairs(pool) do
      selection = selection - v[1] 
      if (selection <= 0) then
         return v[2]
      end
   end
end
function convertToTimeNotation(sec) --a number in seconds
	sec = round(sec, 2) --round to a number of seconds + .00
	local m = math.floor(sec / 60) --we have the total minutes
	local h = math.floor(m / 60) --we have the final hours
	local s = sec - (m * 60) --we have the final seconds.milli
	m = m - (h * 60) --we have the final minutes
	
	local sh, sm, ss
	
	if h < 10 then
		sh = "0"..tostring(h)
	else
		sh = tostring(h)
	end
	
	if m < 10 then
		sm = "0"..tostring(m)
	else
		sm = tostring(m)
	end
	
	if s < 10 then
		ss = "0"..tostring(s)
	else
		ss = tostring(s)
	end
	
	local s = sh..":"..sm..":"..ss
	
	return s
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function deepcopy(orig,src)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key,src)] = deepcopy(orig_value,src)
        end
        setmetatable(copy, deepcopy(getmetatable(orig),src))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[A wrapper for instantiating tables which explicitly checks that the 
	table being instantiated is some form of entity PRIMITIVE, so as to
	avoid deepcopy recursion via object.world and object._p]]
function new(object)
	assert(not object.world and not object._p,'"new" function called on invalid object! object is '..tostring(object))
	return deepcopy(object)
end

function tableAppend(o, n, members, exclude)
	if type(o) ~= "table" then error("tableAppend error: o is not a table!") end
	if type(n) ~= "table" then error("tableAppend error: n is not a table!") end
	local exc = false
	if type(exclude) == 'table' then exc = true end
	local proceed = true
	if type(members) ~= "table" then --f it we're doing it live; copy the whole table over
		for i,v in pairs (n) do
			if exc then if not existsintable(i, exclude) then proceed = true else proceed = false end else proceed = true end	
			if proceed then
				if type(v) == "table" then
					if type(o[i]) ~= "table" then
						o[i] = {}
					end
					o[i] = tableAppend(o[i],n[i])
				else
					local copy = v
					o[i] = copy
				end
			end
		end
	elseif #members > 0 then
		for i=1, #members do
			local m = members[i]
			if type(n[m]) ~= nil then
				if type(n[m]) == "table" then
					if type(o[m]) ~= "table" then
						o[m] = {}
					end
					o[m] = tableAppend(o[m],n[m])
				else
					local copy = n[m]
					o[m] = copy
				end
			end
		end
	else	
		error("tableAppend error members passed in non-indexed table!")
	end
	return o
end
function tableAppend_references(o, n, members, exclude)
	if type(o) ~= "table" then error("tableAppend error: o is not a table!") end
	if type(n) ~= "table" then error("tableAppend error: n is not a table!") end
	local exc = false
	if type(exclude) == 'table' then exc = true end
	local proceed = true
	if type(members) ~= "table" then --f it we're doing it live; copy the whole table over
		for i,v in pairs (n) do
			if exc then if not existsintable(i, exclude) then proceed = true else proceed = false end else proceed = true end	
			if proceed then
				if type(v) == "table" then
					if type(o[i]) ~= "table" then
						o[i] = {}
					end
					o[i] = tableAppend(o[i],n[i])
				else
					o[i] = n[i]
				end
			end
		end
	elseif #members > 0 then
		for i=1, #members do
			if type(n[members[i]]) ~= nil then
				if type(n[members[i]]) == "table" then
					if type(o[members[i]]) ~= "table" then
						o[members[i]] = {}
					end
					o[members[i]] = tableAppend(o[members[i]],n[members[i]])
				else
					o[members[i]] = n[members[i]]
				end
			end
		end
	else	
		for k,v in pairs(o) do
			if type(n[k]) ~= nil then
				if type(n[k]) == 'table' then
					if type(o[k]) ~= 'table' then
						o[k] = {}
					end
					o[k] = tableAppend_references(o[k])
				else
					o[k] = n[k]
				end
			end
		end
	end
	return o
end
function tablePrint(t, name, tab, exclude, limit)
	local stop = false
	if not limit then limit = 2 end
	if limit then if limit == 1 then stop = true else limit = limit - 1 end end
	name = name or "table"
	tab = tab or ""
	print(tostring(tab).."  "..tostring(name).."= {")
	for i,v in pairs(t) do
		if i ~= exclude then
			if (type(v) == "table") then
				if not stop then tablePrint(t[i], i, tostring(tab).."  ",exclude,limit) 
					else print(tostring(tab).."    "..tostring(i).."= "..tostring(v))
				end

			else
			print(tostring(tab).."    "..tostring(i).."= "..tostring(v))
			end
		end
	end
	print(tostring(tab).."    ".."}")
end
function tablePrint_shallow(t,name)		--sick of mistyping this
	tablePrint_Shallow(t,name)
end

function tablePrint_Shallow(t,name)
	name = name or "table"
	print(tostring(name).." = {")
	for i,v in pairs(t) do
		print("   "..tostring(i).." = "..tostring(v))	
	end
	print("}")
end
function loadImageDataFromPath( filePath )
    local f = io.open( filePath, "rb" )
    if f then
        local data = f:read( "*all" )
        f:close()
        if data then
            data = love.filesystem.newFileData( data, "tempname" )
            data = love.image.newImageData( data )
            local image = love.graphics.newImageData( data )
            return image
        end
    end
end
function tableDefault(item,default)		--combine two tables, ignoring values already set in item
	assert({type(item)=='table' and type(default)=='table'},'item '..tostring(item)..' and default '..tostring(default)..'are not both tables!')
	for k,v in pairs(default) do
		if not item[k] then 
			if isTable(v) then item[k] = deepcopy(v)
			else item[k] = v end
		end
	end
end
function newFont_Sizes(fontname,tf,n)
	name = n or fontname or 'default'
	name = string.lower(name)
	tf = tf or 0	--tinyfont - you can pass the smallest font increment and it'll scale it up from there
	local sizetable = {t = 8+tf, s = 10+tf, m = 12+tf, l = 16+tf, xl = 18+tf, xxl = 20+tf, xxxl = 24+tf, xxxxl = 42+tf}
	for i,v in pairs(sizetable) do
		if fontname then
			local f = lg.newFont('fonts/'..fontname..'.ttf',v)
			_G.fonts[(name..'_'..string.lower(tostring(i)))] = f
		else
			local f = lg.newFont(v)
			_G.fonts[('default'..'_'..string.lower(tostring(i)))] = f
		end
	end

end

function addWrapped(value,max)
	if value <= max then return value
	else return value-max end
end

function evaluate(cmd,v) -- this uses recursion to solve math equations
    --[[ We break it into pieces and solve tiny pieces at a time then put them back together
        Example of whats going on
        Lets say we have "5+5+5+5+5"
        First we get this:
        5+5+5+5 +   5
        5+5+5   +   5
        5+5 +   5
        5   +   5
        Take all the single 5's and do their opperation which is addition in this case and get 25 as our answer
        if you want to visually see this with a custom expression, uncomment the code below that says '--print(l,o,r)'
    ]]
    v=v or 0
    local count=0
    local function helper(o,v,r)-- a local helper function to speed things up and keep the code smaller
        if type(v)=="string" then
            if v:find("%D") then
                v=tonumber(math[v]) or tonumber(_G[v]) -- This section allows global variables and variables from math to be used feel free to add your own enviroments
            end
        end
        if type(r)=="string" then
            if r:find("%D") then
                r=tonumber(math[r]) or tonumber(_G[r]) -- A mirror from above but this affects the other side of the equation
                -- Think about it as '5+a' and 'a+5' This mirror allows me to tackle both sides of the expression
            end
        end
        local r=tonumber(r) or 0
        if o=="+" then -- where we handle different math opperators
            return r+v
        elseif o=="-" then
            return r-v
        elseif o=="/" then
            return r/v
        elseif o=="*" then
            return r*v
        elseif o=="^" then
            return r^v
        end
    end
    for i,v in pairs(math) do
        cmd=cmd:gsub(i.."(%b())",function(a)
            a=a:sub(2,-2)
            if a:sub(1,1)=="-" then
                a="0"..a
            end
            return v(evaluate(a))
        end)
    end
    cmd=cmd:gsub("%b()",function(a)
        return evaluate(a:sub(2,-2))
    end)
    for l,o,r in cmd:gmatch("(.*)([%+%^%-%*/])(.*)") do -- iteration this breaks the expression into managable parts, when adding pieces into
        --print(":",l,o,r) -- uncomment this to see how it does its thing
        count=count+1 -- keep track for certain conditions
        if l:find("[%+%^%-%*/]") then -- if I find that  the lefthand side of the expression contains lets keep breaking it apart
            v=helper(o,r,evaluate(l,v))-- evaluate again and do the helper function
        else
            if count==1 then
                v=helper(o,r,l) -- Case where an expression contains one mathematical opperator
            end
        end
    end
    if count==0 then return (tonumber(cmd) or tonumber(math[cmd]) or tonumber(_G[cmd])) end
    -- you can add your own enviroments as well... I use math and _G
    return v
end
function raw2color(r, g, b, a)
	if type(r) == 'table' then
		r, g, b, a = unpack(r)
	end
	return r / 255, g / 255, b / 255, a and a / 255
end
function guitableprint(t, name, x, y, font, color, tab, offset,depth)
	setparams = false
	if tab == nil then setparams = true end
	name = name or "table"
	x = x or 100
	y = y or 100
	font = font or 'defaultfont'
	color = color or {1,1,1,1}
	tab = tab or ""
	offset = offset or 0
	depth = depth or 3
	if setparams then
		lg.setColor(color)
		lg.setFont(_G.fonts[font])
	end
	lg.print(tostring(tab)..tostring(name).." = {",x,y+offset)
	if depth > 0 then
		for i,v in pairs(t) do
			offset = offset + _G.fonts[font]:getHeight("W")
			if type(v) == "table" then
				guitableprint(t[i], i, x, y, font, color, tostring(tab).."  ",offset,depth-1)
			else
				lg.print(tostring(tab).."    "..tostring(i).."= "..tostring(v),x+100,y+offset)
			end
		end
	end
	lg.print(tostring(tab).."		   ".."}")
end
function guitableprint_shallow(t, name, x, y, font, color, offset)
	name = name or "table"
	x = x or 100
	y = y or 100
	font = font or 'defaultfont'
	color = color or {1,1,1,1}
	offset = offset or 0
	lg.print(tostring(tab)..tostring(name).." = {",x,y+offset)
	for i,v in pairs(t) do
		offset = offset + _G.fonts[font]:getHeight("W")+4
		lg.print("    "..tostring(i).."= "..tostring(v),x,y+offset)
	end
	lg.print(tostring(tab).."		   ".."}")
end
function guiprint(p,x,y,font,color)
	p=p or 'nil'
	x=x or 0
	y=y or 0
	font = font or 'defaultfont_s'
	color = color or {1,1,1,1}
	lg.setColor(color)
	lg.setFont(_G.fonts[font])
	lg.print(p,x,y)
end
function horizontaltableprint(t,x,y,font,color,limit)
	local setparams = false
	if font == nil then setparams = true end    
    x = x or 40
	y = y or 100
	font = font or 'defaultfont_s'
	color = color or {1,1,1,1}
    limit = limit or 10
    local printstring = " "
	for i,v in pairs(t) do
        if limit < 0 then break end
        printstring = printstring..tostring(i).."="..tostring(v)..", "
        limit = limit - 1
    end
	printstring = printstring.."}"
    lg.print(printstring,x,y)
    if setparams then
		lg.setColor(color)
		lg.setFont(_G.fonts[font])
	end
end

function displayInputs(t, name, x, y, font, color, offset)
	local setparams = false
	name = name or "table"
	x = x or 40
	y = y or 100
	font = font or 'defaultfont_s'
	color = color or {1,1,1,1}
	tab = tab or ""
	offset = offset or 0
	depth = depth or 3
	if setparams then
		lg.setColor(color)
		lg.setFont(_G.fonts[font])
	end
	lg.print("inputs = {",x,y+offset)
	for i,v in pairs(t) do
		offset = offset + _G.fonts[font]:getHeight("W")
		if type(v) == "table" then
			lg.print(tostring(tab).."  "..tostring(i).."= {",x+20,y+offset)
			local width = _G.fonts[font]:getWidth(tostring(tab).."  "..tostring(i).."= ")
			horizontaltableprint(t[i], x+10+width, y+offset,font,color)
		else
			lg.print(tostring(tab).."    "..tostring(i).."= "..tostring(v),x+20,y+offset)
		end
	end
	lg.print("}",x,y+offset)
end


function rgbHSLmod(r,g,b,nh,ns,nl)
	local h,s,l = rgbToHsl(r,g,b)
	return hslToRgb(h+nh,s+ns,l+nl)
end

function mute()
	la.cVolume = la.getVolume()
	la.setVolume(0)
end

function unmute()
	la.setVolume(la.cVolume or 1)
end

function maxVolume()
	la.setVolume(1)
end

function newSpriteSheet(imageData, width, height)
    local sheetdata = {}
	local image = lg.newImage(imageData)
	if type(imageData) == 'string' then imageData = love.image.newImageData(imageData) end
	
    sheetdata.sheet = image;
    sheetdata.quads = {};
	sheetdata.w = width
	sheetdata.h = height
	local imageHeight = image:getHeight()
	local imageWidth = image:getWidth()
	local debugnumber = 0
    for y = 0, imageHeight - height, height do
        for x = 0, imageWidth - width, width do
            sheetdata.quads[#sheetdata.quads+1] = love.graphics.newQuad(x, y, width, height, image:getDimensions())
			--table.insert(sheetdata.quads, )
        end
    end
    return sheetdata
end

function scaleCanvasToWindow(c_w,c_h,ratio_w,ratio_h)
	local w_w, w_h = lg.getWidth(),lg.getHeight()
	ratio_w = ratio_w or 16
	ratio_h = ratio_h or 9
	local w_diff = w_w - c_w
	local h_diff = w_h - c_h

	local scaled_w,scaled_h
	if w_w >= w_h then
		scaled_w = c_w + w_diff
		scaled_h = (scaled_w * ratio_h)/ratio_w
	else
		scaled_h = c_h + h_diff
		scaled_w = (scaled_h * ratio_w)/ratio_h
	end

	w_scale = scaled_w / c_w
	h_scale = scaled_h / c_h
	return w_scale,h_scale
end