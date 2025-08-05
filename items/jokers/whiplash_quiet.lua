local jokerInfo = {
	name = 'Quiet Riot',
	config = {
		extra = {
			mult_mod = 3,
		}
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'whiplash',
		},
        custom_color = 'whiplash',
    }
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.mult_mod, G.GAME.hands and card.ability.extra.mult_mod * G.GAME.hands["Three of a Kind"].played or 0}}
end

function jokerInfo.calculate(self, card, context)

	if card.debuff then
		return
	end

	if context.cardarea == G.jokers and context.joker_main then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod * G.GAME.hands["Three of a Kind"].played}},
			card = context.blueprint_card or card,
			mult_mod = card.ability.extra.mult_mod * G.GAME.hands["Three of a Kind"].played,
		}
	end

end

return jokerInfo