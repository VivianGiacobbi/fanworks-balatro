local jokerInfo = {
    name = 'The Purple Joker',
    config = {
        tarot = 2
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist18", set = "Other"}
    return {vars = { card.ability.tarot } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_purple" })
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff and G.GAME.current_round.hands_played == 0 and next(context.poker_hands['Flush']) then
        local purp = true
        for k, v in ipairs(context.full_hand) do
            if not v:is_suit('Spades', nil, true) then
                purp = false
            end
        end
        if purp then
            for i = 1, math.min(card.ability.tarot, G.consumeables.config.card_limit - #G.consumeables.cards) do
                G.E_MANAGER:add_event(Event({func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'imthepurpleone')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                        card:juice_up(0.3, 0.5)
                    end
                    return true end }))
            end
        end
    end
end

return jokerInfo
