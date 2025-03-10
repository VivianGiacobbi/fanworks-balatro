local jokerInfo = {
    name = 'Ms. Lambiekins',
    config = {
        extra = {
			money = 1
		}
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    hasSoul = true,
    fanwork = 'gotequest',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = { card.ability.extra.money } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if v.ability.effect == "Lucky Card" then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if not context.individual or not context.cardarea == G.play or card.debuff then
        return
    end
    if context.other_card.ability.effect ~= "Lucky Card" then
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