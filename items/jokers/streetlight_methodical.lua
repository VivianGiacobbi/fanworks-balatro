local jokerInfo = {
	name = 'Methodical Joker',
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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
	artist = 'leafy',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.hands_val, card.ability.extra.current_hands } }
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers then
		if not context.blueprint and not context.retrigger_joker and context.discard and card.ability.extra.current_hands > 0 then
			card.ability.extra.current_hands = 0
			return {
                card = card,
                message = localize('k_reset')
            }
		end

		if context.before then
			if card.ability.extra.current_hands + 1 >= card.ability.extra.hands_val then		
				return {
					card = context.blueprint_card or card,
					level_up = true,
					message = localize('k_method_4')
				}
			elseif not context.blueprint and not context.retrigger_joker then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_method_'..card.ability.extra.current_hands+1)})
			end
		end

		if context.after and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.current_hands = card.ability.extra.current_hands + 1
			if card.ability.extra.current_hands >= card.ability.extra.hands_val then
				card.ability.extra.current_hands = 0
			end
		end
	end
end

return jokerInfo