local mod_path = SMODS.current_mod.path
usable_path = mod_path:match("Mods/[^/]+")
path_pattern_replace = usable_path:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

--- Linear interpolation of a to b, given time t
--- @param a number Value to lerp from
--- @param b number Value to lerp to
--- @param t number Lerp/time variable, between 0 and 1
--- @return number # Interpolated value between a and b
function math.lerp(a,b,t) 
	return (1-t)*a + t*b 
end

function RecursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. RecursiveEnumerate(path)
		end
	end
	return fileTree
end

--- Load an item definition using SMODS
--- @param file_key string file name to load within the "Items" directory, excluding file extension
--- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
--- @param no_badges boolean | nil Whether or not to display mod badges on this item
function LoadItem(file_key, item_type, no_badges)
	local key = string.lower(item_type)..'s'
	local info = assert(SMODS.load_file("items/" .. key .. "/" .. file_key .. ".lua"))()

	if info.in_progress and not fnwk_enabled['enableWipJokers'] then
		return
	end

	info.key = file_key
	if item_type ~= 'Challenge' then
		info.atlas = file_key
		info.pos = { x = 0, y = 0 }
		if info.hasSoul then
			info.pos = { x = 1, y = 0 }
			info.soul_pos = { x = 2, y = 0 }
		end
	end

	if no_badges then
		info.no_mod_badges = true
	elseif info.fanwork then
		info.no_mod_badges = true
		info.set_badges = function(self, card, badges)
			local title = localize('ba_'..info.fanwork)
			local color = HEX(localize('co_'..info.fanwork))
			local text = G.localization.misc.dictionary['te_'..info.fanwork] and HEX(localize('te_'..info.fanwork)) or G.C.WHITE
			badges[#badges+1] = create_badge(title, color, text, 1)
		end
	end

	if item_type == 'Blind' and info.color then
		info.boss_colour = info.color
		info.color = nil
	end

	local smods_item = item_type
	if item_type == 'Stand' then smods_item = 'Consumable' end
	if item_type == 'Deck' then smods_item = 'Back' end
	local new_item = SMODS[smods_item](info)
	for k_, v_ in pairs(new_item) do
		if type(v_) == 'function' then
			new_item[k_] = info[k_]
		end
	end

	SMODS.Atlas({ key = file_key, path = key .. "/" .. file_key .. ".png", px = new_item.width or 71, py = new_item.height or  95 })
	if info.alt_art then
		SMODS.Atlas({ key = file_key..'_alt', path = "jokers/" .. file_key .. '_alt'.. ".png", px = 71, py = 95 })

	end
end

--- Checks total discovered cards that use the 'fnwk_' mod prefix
--- @param exclude table | nil An SMODS object to exclude from the count (usually the one calling the check)
--- @return integer discovered Number of currently discovered cards
--- @return integer total Total number of fanworks cards
function CheckFanworksDiscoveries(exclude)
    local count = 0
    local discovered = 0
    for k, v in pairs(G.P_CENTERS) do
        if string.sub(k, 3, 6) == 'fnwk' and (not exclude or k ~= exclude.config.key) then
            count = count + 1
            if v.config.discovered then
                discovered = discovered + 1
            end
        end
    end

    return discovered, count
end

--- Checks if a string starts with a specified substring
--- @param str string String to check
--- @param start string Substring to search for within str
--- @return boolean # If the string starts with the substring
function StringStartsWith(str, start)
	return string.sub(str, 1, #start) == start
end

--- Checks if a string ends with a specified substring
--- @param str string String to check
--- @param ending string Substring to search for within str
--- @return boolean # If the string end with the substring
function StringEndsWith(str, ending)
	return string.sub(str, -#ending) == ending
end

--- Finds a substring within a given string, not case sensitive
--- @param str string String to check
--- @param substring string Substring to search for within str
--- @return boolean # If the substring is found anywhere within str
function ContainsString(str, substring)
	local lowerStr = string.lower(str)
	local lowerSubstring = string.lower(substring)
	return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
end

--- Searches for a value (not a key) within a table
--- @param table table Table to search for a given value
--- @param element any Value to search within the table
--- @return boolean # If the table contains at least one instance of this value
function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

--- Deep compares the values of tables, rather than their memory IDs
--- @param tbl1 string First table
--- @param tbl2 string Second table
--- @return boolean # If every key and value on the table is identical
function DeepCompare(tbl1, tbl2)
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
					if not DeepCompare(value1, value2) then
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

--- Sine Wave easing function both in and out
--- @param x string Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function EaseInOutSin(x)
	return -(math.cos(math.pi * x) - 1) / 2
end

--- x^4 easing function both in and out
--- @param x string Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function EaseInOutQuart(x) 
	return x < 0.5 and 8 * x * x * x * x or 1 - (-2 * x + 2)^4 / 2;
end


--- Factorial of non-negative integer
--- @param n integer
--- @return number # Factorial of n
function Fact (n)
	if n <= 0 then
	  return 1
	else
	  return n * Fact(n-1)
	end
end

--- Recursively deep copies a table, rather than returning a table reference
--- @param orig table Original table to copy
--- @return table copy Copied table with a unique identity
function DeepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
		end
		setmetatable(copy, DeepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

--- Find a card key in the G.WOMEN table
--- @param key string card object key
--- @return table # Table with three properties, 'junkie, 'trans', and 'cis'. Each will be true or nil if the key is found in each list
function FindWomen(key) 
    local junkie = G.WOMEN.junkies[key]
    local trans = G.WOMEN.trans[key]
    local cis = G.WOMEN.cis[key]
    return {junkie = junkie, trans = trans, cis = cis}
end

--- Sets a discount for specific cards rather than a
--- global discount and updates all instanced cards' costs
--- @param source Card Balatro Card table indicating the source of the discount
--- @param center_set string | nil Set to limit the discount to ('Booster', 'Tarot', 'Joker', etc)
function SetCenterDiscount(source, juice, center_set)
    G.GAME.extra_discounts[source.ID] = {
		center_set = center_set,
		discount = source.ability.extra
	}
    for _, v in pairs(G.I.CARD) do
        if v.set_cost then 
            v:set_cost()
			if juice and (not center_set or (v.ability and v.ability.set == center_set)) then 
				v:juice_up()
			end
        end
    end
	if juice then play_sound('generic1') end
end

--- Clears any set discounts keyed with source's ID
--- and updates all instanced cards' costs
--- @param source Card Balatro Card table indicating the source of the discount
function ClearCenterDiscountSource(source)
	G.GAME.extra_discounts[source.ID] = nil
	for _, v in pairs(G.I.CARD) do
        if v.set_cost then 
            v:set_cost()
        end
    end
end

--- Formats a numeral for display. Numerals between 0 and 1 are written out fully
--- @param n number Numeral to format
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function FormatDisplayNumber(n, caps_style)
	local dict = {
		[0] = 'zero',
		[1] = 'one',
		[2] = 'two',
		[3] = 'three',
		[4] = 'four',
		[5] = 'five',
		[6] = 'six',
		[7] = 'seven',
		[8] = 'eight',
		[9] = 'nine',
		[10] = 'ten',
	}
	if n < 0 or n > #dict then
		return n
	end

	local ret = dict[n]
	local style = caps_style and string.lower(caps_style) or 'lower'
	if style == 'upper' then
		ret = string.upper(ret)
	elseif style == 'first' then
		ret = ret:gsub("^%l", string.upper)
	end

	return ret
end

--- Formats an integer count for grammatically correct display (once, twice, 3 times, etc)
--- @param n number integer to format
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function CountGrammar(value, caps_style, spell_numeral)
    caps_style = caps_style and string.lower(caps_style) or 'lower'
    local ret = ''
    if value == 1 then
        ret = 'once'
    elseif value == 2 then
        ret = 'twice'
    else
        ret = 'times'
    end

    if caps_style == 'first' then
        ret = (ret:gsub("^%l", string.upper))
    elseif caps_style == 'upper' then
        ret = string.upper(ret)
    end
    
    if value > 2 then
		local val = value
		if spell_numeral then
			val = FormatDisplayNumber(value)
			if caps_style == 'first' then
				ret = string.lower(ret)
				val = val:gsub("^%l", string.upper)
			end
		end
        ret = val..' '..ret
    end
    
    return ret
end

--- Finds the number of secret hands played this run
--- @return integer # Number of secret hands played. 0 if no game is active
function SecretHandsPlayed()
	if not G.GAME then
		return 0
	end

	local secret = 0
	for _, key in ipairs(SMODS.PokerHand.obj_buffer) do
		if not SMODS.PokerHands[key].visible and G.GAME.hands[key].played > 0 then
			secret = secret + 1
		end
	end

	return secret
end