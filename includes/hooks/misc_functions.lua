---------------------------
--------------------------- Fibonacci calculation
---------------------------

local valid_fib_cards = {
	'j_fnwk_plancks_jokestar',
	'c_fnwk_plancks_moon',
	'c_jojobal_steel_tusk_4',
}

function fnwk_has_valid_fib_card()
	for _, v in ipairs(valid_fib_cards) do
		if next(SMODS.find_card(v)) then
			return true
		end
	end

	return false
end


local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function jojobal_get_fibonacci(hand)
	local ret = {}
	if #hand < 5 then return ret end
	local vals = {}
	for i = 1, #hand do
		local value = hand[i].base.nominal
		if hand[i].base.value == 'Ace' then
			value = 1
		elseif SMODS.has_no_rank(hand[i]) then
			value = 0
		end
		
		vals[#vals+1] = value
	end
	table.sort(vals, function(a, b) return a < b end)

	if not vals[1] == 0 and not (is_perfect_square(5 * vals[1]^2 + 4) or is_perfect_square(5 * vals[1]^2 - 4)) then
		return ret
	end

	local sum = 0
	local prev_1 = vals[1]
	local prev_2 = 0
	for i=1, #vals do
		sum = prev_1 + prev_2
		
		if vals[i] ~= sum then
			return ret
		end

		prev_2 = prev_1
		prev_1 = vals[i] == 0 and 1 or vals[i]
	end

	local t = {}
	for i=1, #hand do
		t[#t+1] = hand[i]
	end

	table.insert(ret, t)
	return ret
end





---------------------------
--------------------------- pool modification
---------------------------

local ref_current_pool = get_current_pool
function get_current_pool(...)
	local ret = {ref_current_pool(...)}
	if G.GAME.starting_params.fnwk_jokers_rate then
		local new_pool = {}
		for _, v in ipairs(ret[1]) do
			local fnwk_rate = ArrowAPI.string.starts_with(v, 'j_fnwk') and G.GAME.starting_params.fnwk_jokers_rate or 1
			for j=1, fnwk_rate do
				new_pool[#new_pool+1] = v
			end
		end
		ret[1] = new_pool -- setting the pool arg
	end

	return unpack(ret)
end

local name_map = {
    ['GEOMETRICAL DOMINATOR'] = 0,
    ['FINGERBANG'] = 1,
    ['STEREO MADNESS'] = 2,
    ['CLUTTERFUNK'] = 3,
    ['STAY INSIDE ME'] = 4,
    ['ELECTRODYNAMIX'] = 5,
    ['HEXAGON FORCE'] = 6,
    ['ELECTROMAN ADVENTURES'] = 7,
    ['TIME MACHINE'] = 8,
}

G.FUNCS.fnwk_geo_func = function(e)
	local card = e.config.ref_table
	if not card then return end

    card.ability.fnwk_geo_name = e.config.object.string
	if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end
	
	card.children.center:set_sprite_pos({x = name_map[card.ability.fnwk_geo_name], y = 0})  
end

local ref_localize = localize
function localize(...)
	local unpack_args = {...}
	local args = unpack_args[1]

	if args and not (type(args) == 'table') then
		return ref_localize(...)
	end

  	if args.type == 'name' and args.key == 'c_fnwk_double_geometrical' then
		local name = G.localization.descriptions[args.set][args.key]
		local loc_target = { name_parsed = name.name_parsed or {loc_parse_string(name.name)}}

		args.AUT = {}
		args.AUT.box_colours = {}
		local dyn_nodes = {}
		local final_size = 0
		local part_s = nil
		local part_f = nil
		local part_b = nil
		local part_x = nil

		for _, lines in ipairs(loc_target.name_parsed) do
			local final_name_assembled_string = ''
			for _, part in ipairs(lines) do
				local assembled_string_part = ''
				for _, subpart in ipairs(part.strings) do
					assembled_string_part = assembled_string_part..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]) or 'ERROR')
				end
				final_name_assembled_string = final_name_assembled_string..assembled_string_part

				if part.control.s then
					local scale = tonumber(part.control.s) < part_s 
					part_s = scale < part_s and scale or part_s
				end

				-- essentially, only get the values of the first tag part for this name
				if not part_f and part.control.f then
					part_f = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)]
				end
				
				if not part_v and part.control.V then part_v = args.vars.colours[tonumber(part.control.V)] end
				if not part_c and part.control.C then part_c = loc_colour(part.control.C) end

				if not part_b and part.control.B then part_b = args.vars.colours[tonumber(part.control.B)] end
				if not part_x and part.control.X then part_x = loc_colour(part.control.X) end
			end

			if #final_name_assembled_string > final_size then
				final_size = #final_name_assembled_string
			end

			dyn_nodes[#dyn_nodes+1] = { string = final_name_assembled_string, colour = part_v or part_c }
		end

		local desc_scale = G.LANG.font.DESCSCALE
		if G.F_MOBILE_UI then desc_scale = desc_scale*1.5 end

		local final_name = {{
			n=G.UIT.R,
			config={align = "m" },
			nodes = {
				{ n=G.UIT.C,
				config={align = "m", colour = part_b or part_x or nil, r = 0.05, padding = 0.03, res = 0.15},
				nodes={}},

				{ n=G.UIT.O,
				config={
					func = "fnwk_geo_func",
					object = DynaText({
						string = dyn_nodes,
						colours = {G.C.UI.TEXT_LIGHT},
						bump = true,
						silent = true,
						pop_in_rate = 7,
						random_element = true,
						random_no_repeat = true,
						min_cycle_time = 0.12,
						pop_delay = 0.36,
						maxw = 5,
						shadow = true,
						y_offset = -0.6,
						spacing = math.max(0, 0.32*(17 - final_size)),
						font = part_f,
						scale =  (0.55 - 0.004*final_size)*(part_s or 1)
					})}
				}
			}
		}}
	
		return final_name
  	end

	if args.type == 'other' and args.key == 'playing_card' and args.set == 'Other' then
		if G.GAME.modifiers.fnwk_no_suits then
			args.key = 'fnwk_playing_card_nosuit'
		elseif G.GAME.modifiers.fnwk_obscure_suits then
			local obscure_suit = G.GAME.modifiers.fnwk_obscure_suits[args.vars.suit_key]
			args.key = 'fnwk_playing_card_bkg'
			args.vars[2] = localize(obscure_suit.key, 'fnwk_suits_plural')
			args.vars.colours[1] = obscure_suit.r_replace
		end
	elseif G.GAME.modifiers.fnwk_no_rank_chips and args.type == 'other' and args.key == 'card_chips' then
		args.key = 'fnwk_card_chips_none'
	end

	return ref_localize(...)
end

---------------------------
--------------------------- Joker proxies for Bolt blind
---------------------------

local ref_save_run = save_run
function save_run(...)
	if G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_fnwk_bolt' then
		fnwk_reset_blind_proxies()
		local ret = ref_save_run(...)
		fnwk_set_blind_proxies()
		return ret
	end

	return ref_save_run(...)
end


function fnwk_single_blind_proxy(joker)
    local ability_orig = joker.ability
    local extra_orig = type(joker.ability.extra) == 'table' and joker.ability.extra or nil

    G.GAME.blind.fnwk_table_refs[joker.unique_val] = {
        ability = ability_orig,
        extra = extra_orig
    }

    joker.ability = {}
    if extra_orig then
        joker.ability.extra = {}
        setmetatable(joker.ability.extra, {
            __newindex = function (t,k,v) end,

            __index = function (t,k)
                return extra_orig[k] 
            end
        })
    end

    setmetatable(joker.ability, {
        __newindex = function (t,k,v) 
            if (k == 'extra' and type(ability_orig[k]) == 'table') or not G.fnwk_valid_scaling_keys[k] then 
				ability_orig[k] = v
			end
        end,

        __index = function (t,k)
            return ability_orig[k]
        end
    })
end

function fnwk_set_blind_proxies()
    G.GAME.blind.fnwk_table_refs = {}
    for _, v in ipairs(G.jokers.cards) do
        fnwk_single_blind_proxy(v)
    end
end

function fnwk_reset_blind_proxies()
    if not G.GAME.blind.fnwk_table_refs then return end

    for k, v in pairs(G.GAME.blind.fnwk_table_refs) do
        local find_joker = nil
        for _, joker in ipairs(G.jokers.cards) do
            if joker.unique_val == k then
                find_joker = joker
            end
        end

        if find_joker then
            find_joker.ability = v.ability
            setmetatable(find_joker.ability, nil)
            if type(v.extra) == 'table' then
                find_joker.ability.extra = v.extra
                setmetatable(find_joker.ability.extra, nil)
            end
        end
    end

    G.GAME.blind.fnwk_table_ref = nil
end






---------------------------
--------------------------- Custom discover unlock type to prevent automatic deck description
---------------------------

local ref_discover_tallies = set_discover_tallies
function set_discover_tallies(...)
	local ret = ref_discover_tallies(...)

	if check_for_unlock then check_for_unlock({type = 'fnwk_discovered_card'}) end
  	return ret
end



---------------------------
--------------------------- The Written Blind behavior
---------------------------

SMODS.Atlas({ key = 'deck_nosuit', path = 'deck_nosuit.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_norank_lc', path = 'deck_norank_lc.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_norank_hc', path = 'deck_norank_hc.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_nosuit_norank', path = 'deck_nosuit_norank.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_obscured', path = 'deck_obscured.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_obscured_nosuit', path = 'deck_obscured_nosuit.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_obscured_norank', path = 'deck_obscured_norank.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'deck_obscured_nosuit_norank', path = 'deck_obscured_nosuit_norank.png', px = 71, py = 95 })

local ref_front_info = get_front_spriteinfo
function get_front_spriteinfo(...)
	local no_suit = G.GAME.modifiers.fnwk_no_suits
	local no_rank = G.GAME.modifiers.fnwk_no_rank_chips
	local obscure = G.GAME.modifiers.fnwk_obscure_suits

	local args = {...}
	local front = args[1]
	if G.fnwk_force_default_fronts
	or (G.OVERLAY_MENU and G.OVERLAY_MENU.config.id == 'customize_deck')
	or (not front.suit or not front.value)
	or (not no_suit and not no_rank and not obscure) then
		return ref_front_info(...)
	end

	local key = 'fnwk_deck'
	local pos = { x = front.pos.x, y = front.pos.y }

	if obscure then
		local obscure_suit = G.GAME.modifiers.fnwk_obscure_suits[front.suit]
		pos.y = obscure_suit.row_pos
		key = key..'_obscured'
	end

	if no_suit then
		key = key..'_nosuit'
	end

	if no_rank then
		key = key..'_norank'

		if not no_suit and not obscure then
			local collab = G.SETTINGS.CUSTOM_DECK.Collabs[front.suit]
			local hc = (SMODS.DeckSkins[collab] and G.SETTINGS.colour_palettes[front.suit] == 'hc') or G.SETTINGS.colourblind_option
			key = key..(hc and '_hc' or '_lc')
		end
	end

	return G.ASSET_ATLAS[key], pos
end