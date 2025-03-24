local jokerInfo = {
	name = 'Methodical Streetlit Joker',
	config = {
		extra = {
			hands_val = 4,
			current_hands = 0,
		},
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'streetlight',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_leafy", set = "Other"}
    return { vars = { card.ability.extra.hands_val, card.ability.extra.current_hands } }
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end
	if context.cardarea == G.jokers then
		if context.discard and card.ability.extra.current_hands > 0 then
			card.ability.extra.current_hands = 0
			return {
                card = card,
                message = localize('k_reset')
            }
		end

		if context.before then
			card.ability.extra.current_hands = card.ability.extra.current_hands + 1
			if card.ability.extra.current_hands >= card.ability.extra.hands_val then
				card.ability.extra.current_hands = 0
				return {
					card = card,
					level_up = true,
					message = localize('k_method_4')
				}
			else
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_method_'..card.ability.extra.current_hands)})
			end
		end
	end
end

return jokerInfo