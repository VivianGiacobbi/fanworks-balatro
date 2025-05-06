local consumInfo = {
    key = 'c_fnwk_lighted_limelight',
    name = 'Limelight',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            edition = 'e_polychrome',
            chance = 7
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'lighted',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, fnwk_enabled['enableQueer'] and 'Queer' or 'Polychrome'}}
end

function consumInfo.calculate(self, card, context)
    if context.before then
        for _, v in ipairs(context.full_hand) do
            if not SMODS.in_scoring(v, context.scoring_hand) and pseudorandom('limelight') < G.GAME.probabilities.normal / card.ability.extra.chance then
                G.FUNCS.csau_flare_stand_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    v:set_edition(card.ability.extra.edition, true)
                    card:juice_up()
                    return true end
                }))
                delay(0.5)
            end
        end
    end
end

return consumInfo