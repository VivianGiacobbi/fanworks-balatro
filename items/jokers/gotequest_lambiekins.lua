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
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'BarrierTrio/Gote',
    programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
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
    if not (context.individual and context.cardarea == G.play) or card.debuff then return end
    if not SMODS.has_enhancement(context.other_card, 'm_lucky') then return end

    return {
        dollars = card.ability.extra.money,
        colour = G.C.MONEY,
        card = context.other_card
    }
end

return jokerInfo