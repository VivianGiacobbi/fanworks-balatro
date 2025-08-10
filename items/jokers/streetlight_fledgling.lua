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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
	artist = 'leafy',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and not card.debuff and card.ability.extra.chips > 0 then
		return {
			colour = G.C.CHIPS,
			chips = card.ability.extra.chips,
		}
	end

	if not context.blueprint and context.after and G.GAME.current_round.hands_played == 0
	and G.GAME.blind.chips > hand_chips*mult then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "chips",
			scalar_value = "chips_mod",
		})
		return {
			message = localize('k_upgrade_ex'),
			colour = G.C.CHIPS,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo