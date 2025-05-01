local jokerInfo = {
	name = 'Fledgling Joker',
	config = {
		extra = {
			chips = 0,
			chips_mod = 15,
		},
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	fanwork = 'streetlight',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.leafy }}
    return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers then
		if context.joker_main and not card.debuff and card.ability.extra.chips > 0 then
			return {
				message = localize{ type='variable', key='a_chips', vars = {card.ability.extra.chips} },
				colour = G.C.CHIPS,
				chip_mod = card.ability.extra.chips, 
			}
		end

		if not context.blueprint and context.after and G.GAME.current_round.hands_played == 0 and G.GAME.blind.chips > hand_chips*mult then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = context.blueprint_card or card
			}
		end
	end
end

return jokerInfo