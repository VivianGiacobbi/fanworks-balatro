local jokerInfo = {
    name = 'Samurai Crackdown',
    config = {
        extra = {
            mult_mod = 5,
			mult = 0
		}
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    fanwork = 'bone',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_stone') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if not context.individual or not context.cardarea == G.play or card.debuff then
        return
    end
    if not SMODS.has_enhancement(v, 'm_stone') then
        return
    end

    ease_dollars(to_big(card.ability.extra.money))
    return {
        message = localize('$')..card.ability.extra.money,
        colour = G.C.MONEY,
        card = context.blueprint_card or card
    }
end

return jokerInfo