local consumInfo = {
    key = 'c_fnwk_rebels_rebel',
    name = 'Rebel Moon',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FD5F55DC', 'FDA200DC' },
        extra = {
            chips = 50,
            mult = 6
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rebels',
    blueprint_compat = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function consumInfo.calculate(self, card, context)
    if context.debuff then return end

    if context.cardarea == G.play and context.individual then
        if SMODS.has_enhancement(context.other_card, 'm_mult') then
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(context.blueprint_card or card, 0.5)
                end,
                extra = {
                    chips = card.ability.extra.chips
                }
            }
        elseif SMODS.has_enhancement(context.other_card, 'm_bonus') then
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(context.blueprint_card or card, 0.5)
                end,
                extra = {
                    mult = card.ability.extra.mult
                }
            }
        end
    end
end

return consumInfo