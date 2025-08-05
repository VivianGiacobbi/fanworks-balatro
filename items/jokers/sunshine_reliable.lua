local jokerInfo = {
	name = "Ol' Reliable",
	config = {
		extra = {
			hands_at_start = {},
            mult_mod = 8,
		},
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
	artist = 'fizzy',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult_mod} }
end


function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and not card.debuff then	
		local hands_this_round = G.GAME.hands[context.scoring_name].played_this_round > 1 and G.GAME.hands[context.scoring_name].played_this_round or 0
        local mult_val = card.ability.extra.mult_mod * hands_this_round
		
		if mult_val > 0 then
			return {
				message = localize { type = 'variable', key = 'a_mult', vars = {mult_val} },
				mult_mod = mult_val,
				card = context.blueprint_card or card
			}
		end
	end
end



return jokerInfo