local consumInfo = {
    name = 'Paperback Writer',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        evolve_key = 'c_fnwk_streetlight_paperback_rewrite',
        extra = {
            spec_rerolls = 1,
            evolve_ante = 9
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'streetlight',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}

    local reroll_num = G.GAME.current_round.fnwk_paperback_rerolls or 0
    local paperback_num = 1
    local paperbacks = SMODS.find_card('c_fnwk_streetlight_paperback')
    for i, v in ipairs(paperbacks) do
        if v == card then
            paperback_num = i
            break
        end
    end

    return { 
        vars = {
            card.ability.extra.spec_rerolls,
            reroll_num >= paperback_num and 1 or 0,
            card.ability.extra.evolve_ante
        }
    }
end

function consumInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.fnwk_paperback_rerolls = G.GAME.current_round.fnwk_paperback_rerolls + 1
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.fnwk_paperback_rerolls = G.GAME.current_round.fnwk_paperback_rerolls - 1
end

function consumInfo.calculate(self, card, context)
    if context.fnwk_change_ante and G.GAME.round_resets.ante >= card.ability.extra.evolve_ante then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.FUNCS.csau_evolve_stand(card)
                return true 
            end
        }))
    end
end

return consumInfo