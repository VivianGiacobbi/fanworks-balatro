local jokerInfo = {
	name = 'Character Sheet',
	config = {
		extra = {
			chips = 0,
            chips_mod = 7,
		},
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'yym',
		},
        custom_color = 'yym',
    },
	artist = 'gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chips, card.ability.extra.chips_mod} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.open_booster and not context.blueprint then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
		SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_value = "chip_mod"
        })
		return {
			message = localize('k_upgrade_ex'),
			colour = G.C.CHIPS,
			card = card
		}
	end

	if context.joker_main and card.ability.extra.chips > 0 then
		return {
			chips = card.ability.extra.chips,
			colour = G.C.CHIPS,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo