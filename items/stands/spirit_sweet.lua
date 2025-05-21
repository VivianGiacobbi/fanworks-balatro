SMODS.Sound({
	key = "sweet_bod",
	path = "sweet_bod.ogg",
})

local consumInfo = {
    name = 'Sweet Bod',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { '7DD75ADC', '588C52DC' },
        extra = {
            create_key = 'j_fnwk_spirit_rotten'
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.P_CENTERS[card.ability.extra.create_key].name} }
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or card.debuff then return end
    
    if not (context.cardarea == G.consumeables and context.end_of_round and G.GAME.blind:get_type() == 'Boss') then return end

    return {
        func = function()
            G.FUNCS.flare_stand_aura(card, 0.5)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                local new_part = create_card('Joker', G.jokers, nil, nil, nil, nil, card.ability.extra.create_key, 'fnwk_sweet_bod')
                new_part:set_edition({negative = true}, true, true)
                new_part.ability.blind_type = G.GAME.blind.config.blind
                new_part:add_to_deck()
                G.jokers:emplace(new_part)
                new_part:juice_up()
            return true end }))
        end,
        extra = {
            message = localize('k_grafted'),
            sound = 'fnwk_sweet_bod',
            message_card = card,
        }    
    }
end

return consumInfo