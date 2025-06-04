local jokerInfo = {
	name = 'Unknown Soldier',
	config = {
		extra = {
			mult_mod = 1,
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'noman',
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
	return { vars = {card.ability.extra.mult_mod, G.GAME.hands and card.ability.extra.mult_mod * G.GAME.hands["High Card"].played or 0}}
end

function jokerInfo.calculate(self, card, context)

	if card.debuff then
		return
	end

	if context.cardarea == G.jokers and context.joker_main then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod * G.GAME.hands["High Card"].played}},
			card = context.blueprint_card or card,
			mult_mod = card.ability.extra.mult_mod * G.GAME.hands["High Card"].played,
		}
	end

end

return jokerInfo