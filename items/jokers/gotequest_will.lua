local jokerInfo = {
	name = 'Will of One',
	config = {
		extra = {
			chips = 0,
			chip_mod = 1,
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'cejai',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.chips > 0 then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

	if context.discard and not context.other_card.debuff then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "chips",
			scalar_value = "chip_mod",
		})
		return {
			extra = {focus = card, message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
			card = card
		}
	end
end

return jokerInfo