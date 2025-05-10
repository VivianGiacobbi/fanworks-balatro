local jokerInfo = {
	name = 'Rotten Graft',
	config = {
        x_mult = 2,
        blind_type = nil,
		extra = {}
    },
	no_doe = true,
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	no_collection = true,
	fanwork = 'spirit',
}

function jokerInfo.in_pool(self, args)
    return false
end

function jokerInfo.loc_vars(self, info_queue, card)
	local main_end = nil
	if card.ability.blind_type then
		local blind = card.ability.blind_type
		local disabled = card.ability.extra.disabled
		local blind_name = disabled and localize('k_blind_disabled_ex') or localize{type ='name_text', key = blind.key, set = 'Blind'}
		main_end = {
			{n=G.UIT.C, config={align = "bm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "m", colour = disabled and G.C.FILTER or get_blind_main_colour(blind.key), r = 0.05, padding = 0.075, shadow = true}, nodes={
					{n=G.UIT.T, config={text = ' '..blind_name..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
				}}
			}}
		}

		local loc_vars = nil
		if blind.name == 'The Ox' then
			loc_vars = {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}
		end
		if blind.loc_vars and type(blind.loc_vars) == 'function' then
			local res = blind:loc_vars() or {}
            loc_vars = res.vars or loc_vars
		end
		info_queue[#info_queue+1] = disabled and {set = 'Other', key = 'fnwk_disabled_blind'} or {set = 'Blind', key = blind.key, vars = loc_vars }
	end
	
	return { 
		vars = {
			card.ability.x_mult
		},
		main_end = main_end
	}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff or not card.ability.blind_type then return end

	local extra_blind = fnwk_create_extra_blind(card, card.ability.blind_type)
	if G.GAME.blind.in_blind and next(SMODS.find_card('j_chicot')) then
		extra_blind:disable()
	end
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea ~= G.jokers or context.blueprint then return end

	if context.blind_disabled then
		card.ability.extra.disabled = true
	end

	if context.end_of_round then
		card.ability.extra.disabled = nil
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if from_debuff then
		-- disables the blind when debuffed ala Luchador
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if v.fnwk_extra_blind == card then
				v:disable()
				break
			end
		end

		return 
	end	

	fnwk_remove_extra_blind(card)
end

return jokerInfo