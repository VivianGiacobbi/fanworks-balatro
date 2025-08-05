local jokerInfo = {
    name = 'Golden Heart',
    config = {
        extra = 7
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    },
    artist = 'gar'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return { vars = { card.ability.extra } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_gold') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) then
		return
	end

    if card.debuff or context.other_card.debuff then
        return
    end

    if not SMODS.has_enhancement(context.other_card, 'm_gold') then
        return
    end

    return {
        mult = card.ability.extra,
        colour = G.C.RED,
        card = context.blueprint_card or card
    }
end

return jokerInfo