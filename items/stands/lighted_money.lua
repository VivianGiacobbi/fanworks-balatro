local consumInfo = {
    key = 'c_fnwk_lighted_money',
    name = 'Money Talks',
    set = 'Stand',
    config = {
        aura_colors = { 'FFE6BCDC', 'FFD081DC' },
        stand_mask = true,
        extra = {
            dollars = 7
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'lighted',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.dollars}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and context.destroy_card and context.cardarea == G.play and SMODS.has_enhancement(context.destroy_card, 'm_gold') then
        context.destroy_card.fnwk_removed_by_moneytalks = true
        return {
            remove = true
        }
    end

    if context.fnwk_card_destroyed and context.removed.fnwk_removed_by_moneytalks then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(context.blueprint_card or card, 0.5)
            end,
            delay = 0.5,
            extra = {
                dollars = card.ability.extra.dollars,
                colour = G.C.MONEY,
            }
        }
    end
end

return consumInfo