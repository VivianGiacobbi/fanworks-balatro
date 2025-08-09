local jokerInfo = {
	name = 'Sharp Joker',
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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
	artist = 'tos',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult_mod, card.ability.extra.mult_mod * G.GAME.unused_discards or 0}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main then
		return {
			mult = card.ability.extra.mult_mod * G.GAME.unused_discards,
			card = context.blueprint_card or card,
		}
	end

	if context.end_of_round and not context.blueprint
	and context.main_eval and G.GAME.current_round.discards_left > 0 then
		return {
			message = localize('k_upgrade_ex'),
			card = card,
			colour = G.C.RED
		}
	end

end

return jokerInfo