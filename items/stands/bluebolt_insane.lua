local consumInfo = {
    name = 'Insane in the Brain',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'fnwk_rainbow', 'FFFFFFDC' },
        extra = {
            cost_mod = 3,
            card_mod = 3,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    width = 142,
    height = 190,
    display_size = {
        w = 71,
        h = 95,
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
    blueprint_compat = false,
    artist = 'squire',
}

local function create_logic(type, legendary, rarity, soulable, forced_key, key_append)
    local center = G.P_CENTERS.b_red
    --should pool be skipped with a forced key
    --should pool be skipped with a forced key
    if not forced_key and soulable and (not G.GAME.banned_keys['c_soul']) then
        for _, v in ipairs(SMODS.Consumable.legendaries) do
            if (type == v.type.key or type == v.soul_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and (not v.in_pool or (type(v.in_pool) ~= "function") or v:in_pool()) then
                if pseudorandom('soul_'..v.key..type..G.GAME.round_resets.ante) > (1 - v.soul_rate) then
                    forced_key = v.key
                end
            end
        end
        if (type == 'Tarot' or type == 'Spectral' or type == 'Tarot_Planet') and
        not (G.GAME.used_jokers['c_soul'] and not SMODS.showman('c_soul')) then
            if pseudorandom('soul_'..type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_soul'
            end
        end
        if (type == 'Planet' or type == 'Spectral') and
        not (G.GAME.used_jokers['c_black_hole'] and not SMODS.showman('c_black_hole')) then
            if pseudorandom('soul_'..type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_black_hole'
            end
        end
    end

    if type == 'Base' then
        forced_key = 'c_base'
    end

    if forced_key and not G.GAME.banned_keys[forced_key] then
        center = forced_key
        type = (G.P_CENTERS[forced_key].set ~= 'Default' and G.P_CENTERS[forced_key].set or type)
    else
        local pool, pool_key = get_current_pool(type, rarity, legendary, key_append)
        center = pseudorandom_element(pool, pseudoseed(pool_key))
		local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(pool, pseudoseed(pool_key..'_resample'..it))
        end
    end

    local front = ((type=='Base' or type == 'Enhanced') and pseudorandom_element(G.P_CARDS, pseudoseed('front'..(key_append or '')..G.GAME.round_resets.ante))) or nil
	return center, front
end

local function get_pack_ui(card, pack)
	local predict_area = CardArea(
		0,
		0,
		(pack.ability.extra * G.CARD_W) * 0.85,
		(G.CARD_H) * 1,
		{
			card_limit = pack.ability.extra,
			type = 'title',
			highlight_limit = 0,
		}
	)

	local booster_obj = pack.config.center

	ArrowAPI.pseudorandom.set_predict_mode(true)
	for i = 1, pack.ability.extra do
		local new_card = nil
		local _card_to_spawn = booster_obj:create_card(pack, i)

		if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
			-- due to SMODS, I have to support creating an actual card here. hopefully pack creators
			-- don't have it materialize before it leaves the pack
			new_card = _card_to_spawn
		else
			center, front = create_logic(
				_card_to_spawn.set,
				_card_to_spawn.legendary,
				_card_to_spawn.rarity,
				_card_to_spawn.soulable,
				_card_to_spawn.key,
				_card_to_spawn.key_append
			)

			new_card = Card(
				0,
				0,
				0.75 * G.CARD_W,
				0.75 * G.CARD_H,
				front,
				front and G.P_CENTERS.c_base or G.P_CENTERS[center],
				{
					bypass_discovery_center = false,
					bypass_discovery_ui = false,
					discover = false,
					bypass_back = G.GAME.selected_back.pos
				}
			)
		end

		predict_area:emplace(new_card)
	end
	-- make sure to unset predict mode once finished
	ArrowAPI.pseudorandom.set_predict_mode(false)
	return predict_area
end

local function advance_pack_seeds()
	for i=1, #G.P_CENTER_POOLS.Booster do
		local booster = G.P_CENTER_POOLS["Booster"][i]
		for j = 1, booster.config.extra do
			local center = nil
			local _card_to_spawn = booster:create_card(booster, j)
			if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
				center = _card_to_spawn.config.center
				_card_to_spawn:remove()
				G.GAME.used_jokers[center.key] = true
			else
				center = create_logic(
					_card_to_spawn.set,
					_card_to_spawn.legendary,
					_card_to_spawn.rarity,
					_card_to_spawn.soulable,
					_card_to_spawn.key,
					_card_to_spawn.key_append
				)
			end
		end
	end
end

function consumInfo.loc_vars(self, info_queue, card)
	return {
        vars = {
            card.ability.extra.card_mod,
            card.ability.extra.cost_mod
        },
        key = self.key..(JoJoFanworks.current_config['enable_InsaneStaticSeed'] and '_alt' or '')
    }
end

function consumInfo.calculate(self, card, context)
	if context.blueprint then return end
	if not context.cardarea == G.jokers then
		return
	end

	if context.ending_shop and not JoJoFanworks.current_config['enable_InsaneStaticSeed'] then
		card:remove_predict_ui()
		advance_pack_seeds()
	end

	if context.stopped_hovering and context.booster == card.ability.current_hover then
		card:remove_predict_ui()
		card.ability.current_hover = nil
	end

	if context.hovering_booster then
		card:remove_predict_ui()
		card.ability.current_hover = context.booster
		card:show_predict_ui(get_pack_ui(card, context.booster), 'bm')
		card:juice_up(0.5, 0.2)
		play_sound('foil2', 0.95 + math.random() * 0.1, 0.3)
	end
end

function consumInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.set_center_discount(card, card.ability.extra.cost_mod, true, 'Booster')
        return true
    end}))
    G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.card_mod
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.clear_discount(card)
        return true
    end}))
    G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - card.ability.extra.card_mod
end

return consumInfo