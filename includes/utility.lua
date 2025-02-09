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