local jokerInfo = {
    name = 'Creeking Bjoestar',
    config = {
        extra = {
            mult = 8,
        }
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'plancks',
}

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		return {
			message = localize {type='variable', key='a_mult', vars={card.ability.extra.mult}},
			colour = G.C.MULT,
			mult_mod = card.ability.extra.mult,
			card = card
		}
	end
end

return jokerInfo