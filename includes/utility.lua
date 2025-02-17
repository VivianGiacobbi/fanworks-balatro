local mod_path = SMODS.current_mod.path
usable_path = mod_path:match("Mods/[^/]+")
path_pattern_replace = usable_path:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace


function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end

function loadConsumable(v)
	local consumInfo = assert(SMODS.load_file("consumables/" .. v .. ".lua"))()

	if (consumInfo.set == "Spectral") or (consumInfo.set == "Stand") or (consumInfo.set == "Tarot") then
		consumInfo.key = consumInfo.key or v
		consumInfo.atlas = v

		consumInfo.pos = { x = 0, y = 0 }
		if consumInfo.hasSoul then
			consumInfo.pos = { x = 1, y = 0 }
			consumInfo.soul_pos = { x = 2, y = 0 }
		end

		local consum = SMODS.Consumable(consumInfo)
		for k_, v_ in pairs(consum) do
			if type(v_) == 'function' then
				consum[k_] = consumInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, path ="consumables/" .. v .. ".png", px = consum.width or 71, py = consum.height or  95 })
	end
end

function starts_with(str, start)
	return string.sub(str, 1, #start) == start
end

function ends_with(str, ending)
	return string.sub(str, -#ending) == ending
end

function containsString(str, substring)
	local lowerStr = string.lower(str)
	local lowerSubstring = string.lower(substring)
	return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function deep_compare(tbl1, tbl2)
	if tbl1 == tbl2 then
		return true
	elseif type(tbl1) == "table" and type(tbl2) == "table" then
		for key1, value1 in pairs(tbl1) do
			local value2 = tbl2[key1]

			if value2 == nil then
				-- avoid the type call for missing keys in tbl2 by directly comparing with nil
				return false
			elseif value1 ~= value2 then
				if type(value1) == "table" and type(value2) == "table" then
					if not deep_compare(value1, value2) then
						return false
					end
				else
					return false
				end
			end
		end

		-- check for missing keys in tbl1
		for key2, _ in pairs(tbl2) do
			if tbl1[key2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

function ease_in_out_sin(x)
	return -(math.cos(math.pi * x) - 1) / 2
end

--[[
   Author: Julio Manuel Fernandez-Diaz
   Date:   January 12, 2007
   (For Lua 5.1)
   
   Modified slightly by RiciLake to avoid the unnecessary table traversal in tablecount()

   Formats tables with cycles recursively to any depth.
   The output is returned as a string.
   References to other tables are shown as values.
   Self references are indicated.

   The string returned is "Lua code", which can be procesed
   (in the case in which indent is composed by spaces or "--").
   Userdata and function keys and values are shown as strings,
   which logically are exactly not equivalent to the original code.

   This routine can serve for pretty formating tables with
   proper indentations, apart from printing them:

      print(table.show(t, "t"))   -- a typical use
   
   Heavily based on "Saving tables with cycles", PIL2, p. 113.

   Arguments:
      t is the table.
      name is the name of the table (optional)
      indent is a first indentation (optional).
--]]

function table.show(t, name, indent)
	local cart     -- a container
	local autoref  -- for self references
 
	--[[ counts the number of elements in a table
	local function tablecount(t)
	   local n = 0
	   for _, _ in pairs(t) do n = n+1 end
	   return n
	end
	]]
	-- (RiciLake) returns true if the table is empty
	local function isemptytable(t) return next(t) == nil end
 
	local function basicSerialize (o)
	   local so = tostring(o)
	   if type(o) == "function" then
		  local info = debug.getinfo(o, "S")
		  -- info.name is nil because o is not a calling level
		  if info.what == "C" then
			 return string.format("%q", so .. ", C function")
		  else 
			 -- the information is defined through lines
			 return string.format("%q", so .. ", defined in (" ..
				 info.linedefined .. "-" .. info.lastlinedefined ..
				 ")" .. info.source)
		  end
	   elseif type(o) == "number" or type(o) == "boolean" then
		  return so
	   else
		  return string.format("%q", so)
	   end
	end
 
	local function addtocart (value, name, indent, saved, field)
	   indent = indent or ""
	   saved = saved or {}
	   field = field or name
 
	   cart = cart .. indent .. field
 
	   if type(value) ~= "table" then
		  cart = cart .. " = " .. basicSerialize(value) .. ";\n"
	   else
		  if saved[value] then
			 cart = cart .. " = {}; -- " .. saved[value] 
						 .. " (self reference)\n"
			 autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
		  else
			 saved[value] = name
			 --if tablecount(value) == 0 then
			 if isemptytable(value) then
				cart = cart .. " = {};\n"
			 else
				cart = cart .. " = {\n"
				for k, v in pairs(value) do
				   k = basicSerialize(k)
				   local fname = string.format("%s[%s]", name, k)
				   field = string.format("[%s]", k)
				   -- three spaces between levels
				   addtocart(v, fname, indent .. "   ", saved, field)
				end
				cart = cart .. indent .. "};\n"
			 end
		  end
	   end
	end
 
	name = name or "__unnamed__"
	if type(t) ~= "table" then
	   return name .. " = " .. basicSerialize(t)
	end
	cart, autoref = "", ""
	addtocart(t, name, indent)
	return cart .. autoref
 end
 
 function fact (n)
	if n <= 0 then
	  return 1
	else
	  return n * fact(n-1)
	end
  end

  function deep_copy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deep_copy(orig_key)] = deep_copy(orig_value)
		end
		setmetatable(copy, deep_copy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end
