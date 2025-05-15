local consumInfo = {
    name = "Opera No. 2",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FF3BBADC', '62CCA2DC' },
        extra = {
            levels = 2,
            min_dollars = 0,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'city',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.levels,
            card.ability.extra.levels > 1 and 's' or '',
            card.ability.extra.min_dollars
        }
    }
end

function consumInfo.calculate(self, card, context)
    if context.before and G.GAME.dollars <= card.ability.extra.min_dollars then
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 1.5)
            end,
            extra = {
                level_up = card.ability.extra.levels,
                message_card = card
            }
        }
    end
end

return consumInfo