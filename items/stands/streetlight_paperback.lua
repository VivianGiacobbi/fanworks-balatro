local consumInfo = {
    name = 'Paperback Writer',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'AEE4F9DC', '009CFDDC' },
        evolve_key = 'c_fnwk_streetlight_paperback_rewrite',
        extra = {
            spec_rerolls = 1,
            evolve_ante = 9
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'piano',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
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
    if context.blueprint or context.joker_retrigger or card.debuff then return end

    if context.ante_change and G.GAME.round_resets.ante >= card.ability.extra.evolve_ante then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                ArrowAPI.stands.evolve_stand(card)
                return true
            end
        }))
    end
end

return consumInfo