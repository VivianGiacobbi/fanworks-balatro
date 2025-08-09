local jokerInfo = {
	name = 'Holy Yo-Yoker',
	config = {
        extra = {
            chips = 0,
            chip_mod = 6,
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
			'love',
		},
        custom_color = 'love',
    },
    artist = 'pink',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

function jokerInfo.calculate(self, card, context)
    if not context.cardarea == G.jokers or card.debuff then
        return
    end

    if not context.blueprint and context.reroll_shop then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_value = "chip_mod",
        })
        return {
            message = localize('k_upgrade_ex'),
            message_card = card
        }
    end

    if context.joker_main and card.ability.extra.chips > 0 then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo