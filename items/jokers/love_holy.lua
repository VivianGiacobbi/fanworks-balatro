local jokerInfo = {
	name = 'Holy Yo-Yoker',
	config = {
        extra = {
            chips = 0,
            chip_mod = 8,
        }
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'love',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.pink}}
    return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

function jokerInfo.calculate(self, card, context)

    if not context.cardarea == G.jokers or card.debuff then
        return
    end

    if not context.blueprint and context.reroll_shop then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
        return {
            message = localize('k_upgrade_ex'),
            message_card = card
        }
    end

    if context.joker_main and card.ability.extra.chips > 0 then
        return {
            message = localize { type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips} },
            chip_mod = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo