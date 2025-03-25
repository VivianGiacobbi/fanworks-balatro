local consumInfo = {
    key = 'c_fnwk_spec_mood',
    name = 'Mood Indigo',
    set = "Spectral",
    cost = 4,
    alerted = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gar", set = "Other"}
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            local replace = G.jokers.cards[1]
            local vanilla_rare = {[1] = 'Common', [2] = 'Uncommon', [3] = 'Rare', [4] = 'Legendary'}
            local _pool, _pool_key = get_current_pool(
                'Joker',
                vanilla_rare[replace.config.center.rarity] or replace.config.center.rarity,
                replace.config.center.rarity == 4,
                'moodindigo'
            )
            local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
            
            -- iteration for unavailable jokers (exactly the same as the create_card function)
            local it = 1
            while center == 'UNAVAILABLE' or center == replace.config.center.key do
                it = it + 1
                center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
            end

            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            local new_joker = Card(replace.T.x, replace.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[center])

            new_joker:add_to_deck()
            new_joker:set_edition(replace.edition)
            G.jokers:emplace(new_joker, nil, nil, nil, nil, 1)

            replace:remove()
            G.GAME.joker_buffer = 0

            new_joker:juice_up(0.3, 0.5)
            card_eval_status_text(new_joker, 'extra', nil, nil, nil, {message = localize('k_joker_replaced'), colour = G.C.DARK_EDITION})
            play_sound('polychrome1')
            return true
        end)
    }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if not G.jokers then
       return false
    end

    return #G.jokers.cards > 0
end


return consumInfo