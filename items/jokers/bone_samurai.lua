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
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
		custom_color = 'bone',
	},
    artist = 'BarrierTrio/Gote',
    programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
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
    if context.debuffed then return end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card
        }
    end

    if context.cardarea ~= G.play or context.blueprint then return end

    if context.destroy_card and SMODS.has_enhancement(context.destroy_card, 'm_stone') and not card.debuff and not context.destroy_card.debuff then
        return {
            delay = 0.45,
            remove = true,
        }
    end

    if context.individual and not context.other_card.debuff and SMODS.has_enhancement(context.other_card, 'm_stone') then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_value = "mult_mod"
        })
    end
end

return jokerInfo