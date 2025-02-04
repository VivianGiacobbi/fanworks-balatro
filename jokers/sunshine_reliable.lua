local jokerInfo = {
	name = "Ol' Reliable",
	config = {
		extra = {
			hands_at_start = {},
            mult_mod = 6,
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'sunshine',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult_mod} }
end


function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and not card.debuff then	
        local mult_val = card.ability.extra.mult_mod * (G.GAME.hands[context.scoring_name].played - G.GAME.hands_at_round_start[context.scoring_name])
		
		if mult_val > 0 then
			return {
				message = localize { type = 'variable', key = 'a_mult', vars = {mult_val} },
				mult_mod = mult_val,
			}
		end
	end
end



return jokerInfo