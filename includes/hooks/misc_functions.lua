---------------------------
--------------------------- pool modification
---------------------------

local ref_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append, ...)
	local pool, key = ref_current_pool(_type, _rarity, _legendary, _append, ...)
	if G.GAME.starting_params.fnwk_jokers_rate then
		local new_pool = {}
		for _, v in ipairs(pool) do
			local rate = 1
			local center = G.P_CENTERS[v]
			if center and center.ability and center.ability.set == 'Joker' and center.original_mod and center.original_mod.id == 'fanworks' then
				rate = G.GAME.starting_params.fnwk_jokers_rate
			end

			for i=1, rate do
				new_pool[#new_pool+1] = v
			end
		end

		return new_pool, key
	end

	return pool, key
end

local ref_localize = localize
function localize(...)
	local unpack_args = {...}
	local args = unpack_args[1]

	if args and not (type(args) == 'table') then
		return ref_localize(...)
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

local born_ranks = {
	[2] = true,
	[5] = true,
	[8] = true,
	[11] = true,
	[14] = true
}

local ref_get_straight = get_straight
function get_straight(hand, min_length, skip, wrap)
	local ret = ref_get_straight(hand, min_length, skip, wrap)

	if next(SMODS.find_card('c_fnwk_gotequest_born')) then
		if #hand < min_length then
			return {}
		else
			local temp_ranks = copy_table(born_ranks)
			local born_ret = {}

			for i=1, #hand do
				local id = hand[i]:get_id()
				if temp_ranks[id] then
					born_ret[#born_ret+1] = hand[i]
					temp_ranks[id] = nil

					if #born_ret >= min_length then
						born_ret.fnwk_valid_born_straight = true
						return {born_ret}
					end
				end
			end
		end
	end

	return ret
end


---------------------------
--------------------------- After the Reset achievements
---------------------------

function set_joker_win()
	check_for_unlock({type = 'fnwk_won_with_jokers'})

	G.PROFILES[G.SETTINGS.profile].last_win_jokers = {}
	for i, v in ipairs(G.jokers.cards) do
		if v.config.center_key and v.ability.set == 'Joker' then
			G.PROFILES[G.SETTINGS.profile].last_win_jokers[v.config.center_key] = true
		end
	end

	for _, v in pairs(G.jokers.cards) do
		if v.config.center_key and v.ability.set == 'Joker' and not (v.config.center.rarity == 4 and G.GAME.starting_params.fnwk_act_force_legend_ante) then
			G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key] = G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key] or {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
			if G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key] then
				G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins = G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins or {}
				G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins[G.GAME.stake] or 0) + 1
				G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
			end
		end
	end
	G:save_settings()
end