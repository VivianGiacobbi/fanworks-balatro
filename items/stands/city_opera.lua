local consumInfo = {
    name = "Opera No. 2",
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FF3BBADC', '62CCA2DC' },
        extra = {
            levels = 2,
            min_dollars = 0,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'city',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
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
    if card.debuff then return end

    if context.before and G.GAME.dollars <= card.ability.extra.min_dollars then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 1.5)
            end,
            extra = {
                level_up = card.ability.extra.levels,
                message_card = flare_card
            }
        }
    end
end

return consumInfo