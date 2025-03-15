local jokerInfo = {
	name = 'Dynamic Duo',
	config = {
        extra = {
            x_mult = 3
        },
    },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'sunshine',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_fizzy", set = "Other"}
	return { vars = { card.ability.extra.x_mult }}
end

function jokerInfo.calculate(self, card, context)  
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		local kings = 0
		local queens = 0
		for i=1, #context.scoring_hand do
			if context.scoring_hand[i]:get_id() == 13 then
				kings = kings + 1
			end
			if context.scoring_hand[i]:get_id() == 12 then
				queens = queens + 1
			end
		end

		if kings > 0 and queens > 0 then
			return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                card = context.blueprint_card or card,
                Xmult_mod = card.ability.extra.x_mult,
            }
		end
	end
end

return jokerInfo