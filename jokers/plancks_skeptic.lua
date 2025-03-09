local jokerInfo = {
	key = 'j_fnwk_plancks_skeptic',
	name = 'Skeptic Creaking Joker',
	config = {},
	rarity = 2,
	cost = 12,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'plancks',
}

local function create_logic(type, legendary, rarity, soulable, forced_key, key_append)
    local center = G.P_CENTERS.b_red
    --should pool be skipped with a forced key
    if not forced_key and soulable and (not G.GAME.banned_keys['c_soul']) then
        for _, v in ipairs(SMODS.Consumable.legendaries) do
            if (type == v.type.key or type == v.soul_set) and not (G.GAME.used_jokers[v.key] and not next(find_joker("Showman")) and not v.can_repeat_soul) and (not v.in_pool or (type(v.in_pool) ~= "function") or v:in_pool()) then
                if pseudorandom('soul_'..v.key..type..G.GAME.round_resets.ante) > (1 - v.soul_rate) then
                    forced_key = v.key
                end
            end
        end
        if (type == 'Tarot' or type == 'Spectral' or type == 'Tarot_Planet') and
        not (G.GAME.used_jokers['c_soul'] and not next(find_joker("Showman")))  then
            if pseudorandom('soul_'..type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_soul'
            end
        end
        if (type == 'Planet' or type == 'Spectral') and
        not (G.GAME.used_jokers['c_black_hole'] and not next(find_joker("Showman")))  then 
            if pseudorandom('soul_'..type..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_black_hole'
            end
        end
    end

    if type == 'Base' then 
        forced_key = 'c_base'
    end

    if forced_key and not G.GAME.banned_keys[forced_key] then 
        center = G.P_CENTERS[forced_key]
        type = (center.set ~= 'Default' and center.set or type)
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
	local predict_cards = {}
	local used_state = {}
	local booster_obj = pack.config.center

	psuedoseed_predict(true)
	for i = 1, pack.ability.extra do
		local center = nil
		local front = nil
		local _card_to_spawn = booster_obj:create_card(pack, i)

		if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
			-- due to SMODS, I have to support creating an actual card here. hopefully pack creators
			-- don't have it materialize before it leaves the pack
			center = _card_to_spawn.config.center
			front = _card_to_spawn.config.card
			_card_to_spawn:remove()
		else
			center, front = create_logic(
				_card_to_spawn.set,
				_card_to_spawn.legendary,
				_card_to_spawn.rarity,
				_card_to_spawn.soulable,
				_card_to_spawn.key,
				_card_to_spawn.key_append
			)
		end

		if center and G.GAME.used_jokers[center] then
			used_state[center] = true
		end

		predict_cards[i] = {
			center = center,
			front = front
		}
		sendDebugMessage('center: '..tostring(center)..' | front: '..tostring(front))
	end
	-- make sure to unset predict mode once finished
	psuedoseed_predict(false)

	local predict_area = CardArea(
		0,
		0,
		(#predict_cards * G.CARD_W) * 0.75,
		(G.CARD_H) * 1,
		{
			card_limit = #predict_cards,
			type = 'title',
			highlight_limit = 0,
		}
	)

	card:juice_up(0.3, 0.2)
	play_sound('paper1', 0.95 + math.random() * 0.1, 0.3)
	for i = 1, #predict_cards do
		local new_card = Card(
			0,
			0,
			0.75 * G.CARD_W,
			0.75 * G.CARD_H,
			predict_cards[i].front,
			predict_cards[i].front and G.P_CENTERS.c_base or G.P_CENTERS[predict_cards[i].center]
		)
		predict_area:emplace(new_card)
	end

	for k, _ in pairs(used_state) do
		G.GAME.used_jokers[k] = nil
	end

	return predict_area
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
	if not context.cardarea == G.jokers then
		return
	end
	if context.stopped_hovering and card.ability.predict_cards and context.booster == card.ability.current_hover then
		card.ability.predict_cards:remove()
		card.ability.current_hover = nil
	end

	if context.hovering_booster then
		if card.ability.predict_cards then
			card.ability.predict_cards:remove()
		end
		card.ability.current_hover = context.booster
		card.ability.predict_cards = get_pack_ui(card, context.booster)
		--[[
		card.ability.predict_ui = UIBox{
			definition = create_UIBox_generic_options({
				no_back = true, 
				contents = {{
					n = G.UIT.O,
					config = {scale = 0.1, object = card.ability.predict_cards}
				}}
			}), 
			config = {align='bm', r = 0.1, maxh = 1, maxw = 5, scale = 0.1, offset = {x = 0,y = 0}, major = card, bond = 'Weak'}
		}
		card.ability.predict_ui:align_to_major()
		--]]
	end
end

return jokerInfo


