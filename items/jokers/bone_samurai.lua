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
    if SMODS.has_enhancement(v, 'm_stone') then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        return {
            message = localize('k_upgrade_ex'),
            card = card,
        }
    end

    return {
        mult = card.ability.extra.mult,
        card = context.blueprint_card or card
    }
end

return jokerInfo