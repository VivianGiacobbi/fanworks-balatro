local consumInfo = {
    name = 'Big Poppa',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            x_mult = 2,
            chance = 2,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'glass',
    in_progress = true,
    blueprint_compat = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = { card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.chance }}
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(context.blueprint_card or card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = context.other_card
            }
        }
    end

    if not context.blueprint and context.destroy_card and context.cardarea == G.play and not context.repetition then
        if SMODS.has_enhancement(context.destroy_card, 'm_stone') and pseudorandom('bigpoppa') < G.GAME.probabilities.normal / card.ability.extra.chance then
            return {
                remove = true
            }
        end
    end
end

return consumInfo