local jokerInfo = {
	name = 'Will of One',
	config = {
		extra = {
			chips = 0,
			chip_mod = 1,
			chips_extra = {
				chips = 0,
				chip_mod = 1,
			}
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = false,
	fanwork = 'gotequest',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

function jokerInfo.calculate(self, card, context)
    if context.debuffed then return end

    if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
        return {
            message = localize{type='variable', key='a_chips', vars = {card.ability.extra.chips} },
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

	if context.discard and not context.other_card.debuff then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
		return {
			extra = {focus = card, message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
			card = card
		}
	end

	if context.individual and context.cardarea == G.play and not context.other_card.debuff then
		card.ability.extra.chips_extra.chips = card.ability.extra.chips_extra.chips + card.ability.extra.chips_extra.chip_mod
		return {
			extra = {focus = card, message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
			card = card
		}
	end

    
end

return jokerInfo