local jokerInfo = {
    key = 'j_fnwk_gotequest_lambiekins',
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
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
    return { vars = { card.ability.extra.money } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_lucky') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) or card.debuff then
        return
    end
    if not SMODS.has_enhancement(context.other_card, 'm_lucky') then
        return
    end

    ease_dollars(card.ability.extra.money)
    return {
        message = localize('$')..card.ability.extra.money,
        colour = G.C.MONEY,
        card = context.blueprint_card or card
    }
end

return jokerInfo