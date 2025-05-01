local consumInfo = {
    name = "The Damned",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', '4F6367DC' },
        extra = {
            suits = {'Spades', 'Clubs'},
            scored_count = 0,
            num_scores = 6,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'sunshine',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.num_scores - card.ability.extra.scored_count,
            localize(card.ability.extra.suits[1], 'suits_plural'),
            localize(card.ability.extra.suits[2], 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]]
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if not (context.cardarea == G.play and context.individual) then return end

    local found_suit = false
    for _, v in pairs(card.ability.extra.suits) do
        if context.other_card:is_suit(v) then
            found_suit = true
            break
        end
    end

    if not found_suit then return end
    card.ability.extra.scored_count = card.ability.extra.scored_count + 1
    if card.ability.extra.scored_count < card.ability.extra.num_scores then
        return {
            message_card = card,
            message = localize{type='variable', key='a_remaining', vars={card.ability.extra.num_scores - card.ability.extra.scored_count}},
            delay = 0.45
        }
    end

    card.ability.extra.scored_count = 0
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    return {
        extra = {
            focus = card,
            message = localize('k_plus_tarot'),
            func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        local new_tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'fnwk_damned')
                        new_tarot:add_to_deck()
                        G.consumeables:emplace(new_tarot)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
            end
        },
        colour = G.C.SECONDARY_SET.Tarot,
        message_card = card
    }
end

return consumInfo