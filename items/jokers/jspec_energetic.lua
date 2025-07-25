local jokerInfo = {
	name = 'Energetic Joker',
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
	fanwork = 'jspec',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.tos }}
	return { vars = {card.ability.extra.mult_mod, card.ability.extra.mult_mod * G.GAME.unused_discards or 0}}
end

function jokerInfo.calculate(self, card, context)

	if card.debuff then
		return
	end

	if context.cardarea == G.jokers and context.joker_main then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod * G.GAME.unused_discards}},
			card = context.blueprint_card or card,
			mult_mod = card.ability.extra.mult_mod * G.GAME.unused_discards,
		}
	end

	if context.end_of_round and not context.blueprint and not context.individual and G.GAME.current_round.discards_left > 0 then
		return {
			message = localize('k_upgrade_ex'),
			card = card,
			colour = G.C.RED
		}
	end

end

return jokerInfo