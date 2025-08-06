local jokerInfo = {
	name = 'Skeptic Joker',
	config = {
		hovered_boosters = {}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'plancks',
		},
        custom_color = 'plancks',
    },
	artist = 'coop',
	alt_art = true
}

local function create_logic(type, legendary, rarity, soulable, forced_key, key_append)
    local center = G.P_CENTERS.b_red
    --should pool be skipped with a forced key
    --should pool be skipped with a forced key
    if not forced_key and soulable and (not G.GAME.banned_keys['c_soul']) then
        for _, v in ipairs(SMODS.Consumable.legendaries) do
            if (_type == v.type.key or _type == v.soul_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and (not v.in_pool or (type(v.in_pool) ~= "function") or v:in_pool()) then
                if pseudorandom('soul_'..v.key.._type..G.GAME.round_resets.ante) > (1 - v.soul_rate) then
                    forced_key = v.key
                end
            end
        end
        if (_type == 'Tarot' or _type == 'Spectral' or _type == 'Tarot_Planet') and
        not (G.GAME.used_jokers['c_soul'] and not SMODS.showman('c_soul')) then
            if pseudorandom('soul_'.._type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_soul'
            end
        end
        if (_type == 'Planet' or _type == 'Spectral') and
        not (G.GAME.used_jokers['c_black_hole'] and not SMODS.showman('c_black_hole')) then
            if pseudorandom('soul_'.._type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_black_hole'
            end
        end
    end

    if _type == 'Base' then 
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
		local booster_obj = G.P_CENTER_POOLS["Booster"][i]
		for j = 1, booster_obj.config.extra do
			local center = nil
			local _card_to_spawn = booster_obj:create_card(booster_obj, j)
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

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {fnwk_enabled['enable_SkepticStaticSeed'] and '' or 'This Joker changes seed progression'}}
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end
	if not context.cardarea == G.jokers then
		return
	end

	if context.ending_shop and not fnwk_enabled['enable_SkepticStaticSeed'] then
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

return jokerInfo


