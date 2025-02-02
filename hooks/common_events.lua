draw_card = function(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    percent = percent or 50
    delay = delay or 0.1 
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = delay,
        func = function()
            if card then 
                if from then card = from:remove_card(card) end
                if card then drawn = true end
                local stay_flipped = (G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card)) or card.joker_force_facedown
                if G.GAME.modifiers.flipped_cards and to == G.hand then
                    if pseudorandom(pseudoseed('flipped_card')) < 1/G.GAME.modifiers.flipped_cards then
                        stay_flipped = true
                    end
                end
                to:emplace(card, nil, stay_flipped)
            else
                if to:draw_card_from(from, stay_flipped, discarded_only) then drawn = true end
            end
            if not mute and drawn then
                if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                    G.VIBRATION = G.VIBRATION + 0.6
                end
                play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
            end
            if sort then
                to:sort()
            end
            return true
        end
      }))
end