---------------------------
--------------------------- Loading/Debug Functions
---------------------------

-- Modified code from Cryptid
function FnwkDynamicBadge(fanwork)
	if not SMODS.config.no_mod_badges then
		local function calc_scale_fac(text)
			local size = 0.9
			local font = G.LANG.font
			local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
			local calced_text_width = 0
			-- Math reproduced from DynaText:update_text
			for _, c in utf8.chars(text) do
				local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
						+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
				calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
			end
			local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
			return scale_fac
		end
		local scale_fac = {}
		local min_scale_fac = 0.4

		local strings = {
			localize('ba_fanworks'),
			localize('ba_'..fanwork)
		}
		local badge_colour = SMODS.Gradients['fnwk_'..fanwork] or (G.fnwk_badge_colours['co_'..fanwork] and HEX(G.fnwk_badge_colours['co_'..fanwork])) or G.C.STAND
		local text_colour = G.fnwk_badge_colours['te_'..fanwork] and HEX(G.fnwk_badge_colours['te_'..fanwork]) or G.C.WHITE

		for i = 1, #strings do
			scale_fac[i] = calc_scale_fac(strings[i])
			min_scale_fac = math.min(min_scale_fac, scale_fac[i])
		end
		local ct = {}
		for i = 1, #strings do
			ct[i] = {
				string = strings[i],
			}
		end
		return {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = badge_colour,
						r = 0.1,
						minw = 1 / min_scale_fac,
						minh = 0.36,
						emboss = 0.05,
						padding = 0.03 * 0.9,
					},
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = ct or "ERROR",
									colours = { text_colour },
									silent = true,
									float = true,
									shadow = true,
									offset_y = -0.03,
									spacing = 1,
									scale = 0.33 * 0.9,
								}),
							},
						},
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
					},
				},
			},
		}
	end
end

--- Load an item definition using SMODS
--- @param file_key string file name to load within the "Items" directory, excluding file extension
--- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
function FnwkLoadItem(file_key, item_type)
	local key = string.lower(item_type)..'s'
	local info = assert(SMODS.load_file("items/" .. key .. "/" .. file_key .. ".lua"))()

	info.key = file_key
	local smods_item = item_type
	if item_type == 'Stand' then
		smods_item = 'Consumable'

		-- add universal set_consumable_usage() for stands
		local ref_add_to_deck = function(self, card, from_debuff) end
		if info.add_to_deck then
			ref_add_to_deck = info.add_to_deck
		end
		function info.add_to_deck(self, card, from_debuff)
			ref_add_to_deck(self, card, from_debuff)

			-- only set initially
			if not from_debuff then
				set_consumeable_usage(card)
			end
			
		end

		-- force no use for stands
		function info.can_use(self, card)
			return false
		end

		-- add universal update to evolved Stand badges
		if info.rarity == 'arrow_EvolvedRarity' then
			local ref_type_badge = function(self, card, badges) end
			if info.set_card_type_badge then
				ref_type_badge = info.set_card_type_badge
			end
			function info.set_card_type_badge(self, card, badges)
				badges[1] = create_badge(localize('k_evolved_stand'), get_type_colour(self or card.config, card), nil, 1.2)
				ref_type_badge(self, card)
			end
		end
	end
	if item_type == 'Deck' then smods_item = 'Back' end

	if item_type == 'Stand' and not G.fnwk_stands_enabled then
		return
	end

	if info.in_progress and not fnwk_enabled['enableWipItems'] then
		return
	end
	
	if item_type ~= 'Challenge' and item_type ~= 'Edition' then
		info.atlas = file_key
		info.pos = { x = 0, y = 0 }
		if info.hasSoul then
			info.pos = { x = 1, y = 0 }
			info.soul_pos = { x = 2, y = 0 }
		end
	end

	if not info.no_mod_badges and info.fanwork then
		info.no_mod_badges = true
		local sb_ref = function(self, card, badges) end
		if info.set_badges then
			sb_ref = info.set_badges
		end
		info.set_badges = function(self, card, badges)
			sb_ref(self, card, badges)
			if card.area and card.area == G.jokers or card.config.center.discovered then
				badges[#badges+1] = FnwkDynamicBadge(info.fanwork)
			end
		end
	end

	local new_item
	if SMODS[smods_item] then
		new_item = SMODS[smods_item](info)
		for k_, v_ in pairs(new_item) do
			if type(v_) == 'function' then
				new_item[k_] = info[k_]
			end
		end
	else
		if CardSleeves and item_type == 'Sleeve' then
			new_item = CardSleeves.Sleeve(info)
			for k_, v_ in pairs(new_item) do
				if type(v_) == 'function' then
					new_item[k_] = info[k_]
				end
			end
		end
	end

    if item_type == 'Challenge' or item_type == 'Edition' then
        -- these dont need visuals
        return
    end

    if item_type == 'Blind' then
        -- separation for animated spritess
        SMODS.Atlas({ key = file_key, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. file_key .. ".png", px = 34, py = 34, frames = 21 })
	else
		local width = 71
		local height = 95
		if item_type == 'Tag' then width = 34; height = 34 end
		if item_type == 'Sleeve' then width = 73 end
        SMODS.Atlas({ key = file_key, path = key .. "/" .. file_key .. ".png", px = new_item.width or width, py = new_item.height or height })
    end
end

function table.fnwk_clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

--- Linear interpolation of a to b, given time t
--- @param a number Value to lerp from
--- @param b number Value to lerp to
--- @param t number Lerp/time variable, between 0 and 1
--- @return number # Interpolated value between a and b
function math.fnwk_lerp(a,b,t) 
	return (1-t)*a + t*b 
end

--- Recursively finds the full file tree at a specified path
--- @param folder string The folder path to enumerate. Function fails if folder is not an OS directory
--- @return string fileTree A string, separated by newlines, of all enumerated paths
function FnwkRecursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. FnwkRecursiveEnumerate(path)
		end
	end
	return fileTree
end

--- Checks total discovered cards that use the 'fnwk_' mod prefix
--- @param exclude table | nil An SMODS object to exclude from the count (usually the one calling the check)
--- @return integer discovered Number of currently discovered cards
--- @return integer total Total number of fanworks cards
function FnwkCheckFanworksDiscoveries(exclude)
    local count = 0
    local discovered = 0
    for k, v in pairs(G.P_CENTERS) do
        if string.sub(k, 3, 6) == 'fnwk' and (not exclude or k ~= exclude.key) then
            count = count + 1
            if v.discovered and v.unlocked then
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
function FnwkStringStartsWith(str, start)
	return string.sub(str, 1, #start) == start
end

--- Checks if a string ends with a specified substring
--- @param str string String to check
--- @param ending string Substring to search for within str
--- @return boolean # If the string end with the substring
function FnwkStringEndsWith(str, ending)
	return string.sub(str, -#ending) == ending
end

--- Finds a substring within a given string, not case sensitive
--- @param str string String to check
--- @param substring string Substring to search for within str
--- @return boolean # If the substring is found anywhere within str
function FnwkContainsString(str, substring)
	local lowerStr = string.lower(str)
	local lowerSubstring = string.lower(substring)
	return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
end

--- Searches for a value (not a key) within a table
--- @param table table Table to search for a given value
--- @param element any Value to search within the table
--- @return boolean # If the table contains at least one instance of this value
function table.fnwk_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

--- Deep compares the values of tables, rather than their memory IDs
--- Object tables are still compared by ID to prevent recursive nesting
--- @param tbl1 table First table
--- @param tbl2 table Second table
--- @return boolean # If every key and value on the table is identical
function FnwkDeepCompare(tbl1, tbl2)
	if type(tbl1) == "table" and type(tbl2) == "table" then
		-- don't do a nested compare for objects, just compare the reference IDs
		if (tbl1.is and tlb1:is(Object)) or (tbl2.is and tbl2:is(Object)) then
			return tbl1 == tbl2
		end

		for k, v in pairs(tbl1) do
			-- avoid the type call for missing keys in tbl2 by directly comparing with nil
			if tbl2[k] == nil then	
				return false
			elseif v ~= tbl2[k] then
				if type(v) == "table" and type(tbl2[k]) == "table" then
					return FnwkDeepCompare(v, tbl2[k])
				else
					return v == tbl2[k]
				end
			end
		end

		-- check for missing keys in tbl1
		for k, _ in pairs(tbl2) do
			if tbl1[k] == nil then
				return false
			end
		end

		-- this means both tables are empty, which are functionally equal
		return true
	end

	-- direct comparison after all other checks
	return tbl1 == tbl2
end

--- Recursively modifies number values in a table given a multipliative mod, or a reset table and comparator conditions to reset from.
--- If no parameters but a table are provided, the function returns a deep copy of all non-object values
--- @param table table A table to modify.
--- @param mod number | nil A modifier value (such as 0.5 or 2). Default is 1
--- @param reset_table table | nil Table to reset directly comparable values from based on comparator
--- @param compare string | nil A comparator to determine when to reset ('pos', 'neg', or 'dif', default is 'neg')
--- @return table # A modified copy of the given table
function FnwkRecursiveTableMod(table, mod, reset_table, compare)
    local val_type = type(table)
    local mod_copy = nil
    if val_type ~= 'table' then
        -- modify number values
        if val_type == 'number' and (not reset_table or type(reset_table) == 'number') then
            -- default value
            mod_copy = table * (mod or 1)

            if not compare then
                compare = 'neg'
            end

            -- reset if a reset table is provided
            if reset_table and ((compare == 'neg' and table < reset_table)
            or (compare == 'pos' and table > reset_table)
            or (compare == 'dif' and table ~= reset_table)) then 
                mod_copy = reset_table
            end

            return mod_copy
        end

        -- weird scenarios with a table mismatch
        return table
    end

    -- recursive to arbitrary depth
    mod_copy = {}
    for k, v in next, table, nil do
        if (k == 'order' and type(v) == 'number') or (type(v) == 'table' and v.is and (v:is(Card) or v:is(Cardarea))) then
            -- don't copy certain values
            mod_copy[k] = v
        else
            if mod and mod ~= 1 and type(v) == 'number' and (k == 'x_mult' or k == 'Xmult' or k == 'x_chips' or k == 'Xchips') then
                if v == 1 then
                    mod_copy[k] = math.max(0, FnwkRecursiveTableMod(0, mod, reset_table and reset_table[k] or nil, compare))
                else
                    mod_copy[k] = math.max(0, FnwkRecursiveTableMod(v - 1, mod, reset_table and reset_table[k] or nil, compare))
                end
            else 
                mod_copy[k] = FnwkRecursiveTableMod(v, mod, reset_table and reset_table[k] or nil, compare)
            end
            
        end
    end

    return mod_copy
end

--- Sine Wave easing function both in and out
--- @param x string Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function FnwkEaseInOutSin(x)
	return -(math.cos(math.pi * x) - 1) / 2
end

--- x^4 easing function both in and out
--- @param x string Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function FnwkEaseInOutQuart(x) 
	return x < 0.5 and 8 * x * x * x * x or 1 - (-2 * x + 2)^4 / 2;
end


--- Factorial of non-negative integer
--- @param n integer
--- @return number # Factorial of n
function FnwkFact (n)
	if n <= 0 then
	  return 1
	else
	  return n * FnwkFact(n-1)
	end
end

--- Find a card key in the G.WOMEN table
--- @param key string card object key
--- @return table # Table with three properties, 'junkie, 'trans', and 'cis'. Each will be true or nil if the key is found in each list
function FnwkFindWomen(key) 
    local junkie = G.fnwk_women.junkies[key]
    local trans = G.fnwk_women.trans[key]
    local woman = G.fnwk_women.women[key]
	local girl = G.fnwk_women.girls[key]
    return {junkie = junkie, trans = trans, woman = woman, girl = girl}
end

--- Sets a discount for specific cards rather than a
--- global discount and updates all instanced cards' costs
--- @param source Card Balatro Card table indicating the source of the discount
--- @param center_set string | nil Set to limit the discount to ('Booster', 'Tarot', 'Joker', etc)
function FnwkSetCenterDiscount(source, discount, juice, center_set)
    G.GAME.fnwk_extra_discounts[source.unique_val] = {
		center_set = center_set,
		discount = discount
	}
    for _, v in pairs(G.I.CARD) do
        if v.set_cost and (not center_set or (v.ability and v.ability.set == center_set)) then 
            v:set_cost()
			v:juice_up()
        end
    end
	if juice then play_sound('generic1') end
end

--- Clears any set discounts keyed with source's ID
--- and updates all instanced cards' costs
--- @param source Card Balatro Card table indicating the source of the discount
function FnwkClearCenterDiscountSource(source)
	G.GAME.fnwk_extra_discounts[source.unique_val] = nil
	for _, v in pairs(G.I.CARD) do
        if v.set_cost then 
            v:set_cost()
        end
    end
end

--- Formats a numeral for display. Numerals between 0 and 1 are written out fully
--- @param n number Numeral to format
--- @param number_type string | nil Type of display number ('number', 'order')
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function FnwkFormatDisplayNumber(n, number_type, caps_style)
	number_type = number_type or 'number'
	local dict = {
		[0] = {number = 'zero', order = 'zeroth'},
		[1] = {number = 'one', order = 'first'},
		[2] = {number = 'two', order = 'second'},
		[3] = {number = 'three', order = 'third'},
		[4] = {number = 'four', order = 'fourth'},
		[5] = {number = 'five', order = 'fifth'},
		[6] = {number = 'six', order = 'sixth'},
		[7] = {number = 'seven', order = 'seventh'},
		[8] = {number = 'eight', order = 'eighth'},
		[9] = {number = 'nine', order = 'ninth'},
		[10] = {number = 'ten', order = 'tenth'},
		[11] = {number = '11', order = '11th'},
		[12] = {number = '12', order = '12th'},
	}
	if n < 0 or n > #dict then
		if number_type == 'number' then return n end

		local ret = ''
		local mod = n % 10
		if mod == 1 then 
			ret = n..'st'
		elseif mod == 2 then
			ret = n..'nd'
		elseif mod == 3 then
			ret = n..'rd'
		else
			ret = n..'th'
		end
		return ret
	end

	local ret = dict[n][number_type]
	local style = caps_style and string.lower(caps_style) or 'lower'
	if style == 'upper' then
		ret = string.upper(ret)
	elseif n < 11 and style == 'first' then
		ret = ret:gsub("^%l", string.upper)
	end

	return ret
end

--- Formats an integer count for grammatically correct display (once, twice, 3 times, etc)
--- @param value number integer to format
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function FnwkCountGrammar(value, caps_style, spell_numeral)
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
			val = FnwkFormatDisplayNumber(value)
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
function FnwkSecretHandsPlayed()
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

function fnwk_filter_loading(item_type)
	if item_type == 'Sleeve' then
		if CardSleeves then
			return true
		end
	else
		return fnwk_enabled['enable'..item_type..'s']
	end
end

function FnwkManualUIReload(hud_offset)
	if G.HUD then G.HUD:remove(); G.HUD = nil end
	if G.HUD_blind then
		-- manually nil out the blind object so this remove call doesn't destroy it unnecessarily
		G.HUD_blind.UIRoot.children[2].children[2].children[1].config.object = nil
		G.HUD_blind:remove();
		G.HUD_blind = nil
	end
	G.HUD = UIBox{
		definition = create_UIBox_HUD(),
		config = {align=('cli'), offset = {x=-0.7,y=0}, major = G.ROOM_ATTACH}
	}
	G.HUD_blind = UIBox{
		definition = create_UIBox_HUD_blind(),
		config = {major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = {x=0,y=hud_offset or -10}, bond = 'Weak'}
	}

	G.hand_text_area = {
		chips = G.HUD:get_UIE_by_ID('hand_chips'),
		mult = G.HUD:get_UIE_by_ID('hand_mult'),
		ante = G.HUD:get_UIE_by_ID('ante_UI_count'),
		round = G.HUD:get_UIE_by_ID('round_UI_count'),
		chip_total = G.HUD:get_UIE_by_ID('hand_chip_total'),
		handname = G.HUD:get_UIE_by_ID('hand_name'),
		hand_level = G.HUD:get_UIE_by_ID('hand_level'),
		game_chips = G.HUD:get_UIE_by_ID('chip_UI_count'),
		blind_chips = G.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
		blind_spacer = G.HUD:get_UIE_by_ID('blind_spacer')
	}
end


function FnwkSetFronts(juice)
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
            if juice then v:juice_up() end
        end
    end
end

function FnwkRandomSuitOrderCall(f, ...)
	local suit_buffer_copy = copy_table(SMODS.Suit.obj_buffer)
    local nominals_list = {}

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        nominals_list[i] = SMODS.Suits[v].suit_nominal
    end

    -- correctly seeded suit order randomization
    math.randomseed((pseudohash('fnwk_multimedia_shuffle'..(G.GAME.pseudorandom.seed or '')) + (G.GAME.pseudorandom.hashed_seed or 0))/2)
    for i = #suit_buffer_copy, 2, -1 do
		local j = math.random(i)
        local key1 = SMODS.Suit.obj_buffer[i]
        local key2 = SMODS.Suit.obj_buffer[j]
		SMODS.Suit.obj_buffer[i], SMODS.Suit.obj_buffer[j] = key2, key1
	end

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suits[v].suit_nominal = nominals_list[i]
    end

    local old_suit_nominals = {}
    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            old_suit_nominals[i] = {
                current = v.base.suit_nominal,
                original = v.base.suit_nominal_original
            }
            v.base.suit_nominal = SMODS.Suits[v.base.suit].suit_nominal
            v.base.suit_nominal_original = v.base.suit_nominal
        end
    end

    local ret = {f(...)}

    -- return the old values
    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suit.obj_buffer[i] = suit_buffer_copy[i]
        SMODS.Suits[SMODS.Suit.obj_buffer[i]].suit_nominal = nominals_list[i]
    end

    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            v.base.suit_nominal = old_suit_nominals[i].current
            v.base.suit_nominal_original = old_suit_nominals[i].original
        end
    end

	return unpack(ret)
end