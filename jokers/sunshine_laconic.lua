local jokerInfo = {
	name = 'Laconic Joker',
	config = {
		extra = {
			chips = 0,
            chips_mod = 10,
		},
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'sunshine',

}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_fizzy", set = "Other"}
	return { vars = {card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
	if context.before and context.cardarea == G.jokers and not card.debuff and not context.blueprint then
        if #context.full_hand <= 3 then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod	
			return {
				message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
				card = card
			}
		elseif card.ability.extra.chips > 0 then
            card.ability.extra.chips = 0
            return {
                card = card,
                message = localize('k_reset')
            }
		end
	end
    
	if context.joker_main and context.cardarea == G.jokers and not card.debuff and card.ability.extra.chips > 0 then
		return {
			message = localize{ type='variable', key='a_chips', vars = {card.ability.extra.chips} },
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		}
	end
end

return jokerInfo