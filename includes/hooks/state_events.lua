---------------------------
--------------------------- Corpse crimelord unlock
---------------------------

local ref_end_round = end_round
function end_round(...)
    local ret = ref_end_round(...)
    G.E_MANAGER:add_event(Event({
        func = function()
            if SMODS.saved then
                check_for_unlock({type = 'saved_from_death'})
            end
            return true
        end
    }))
    return ret
end





---------------------------
--------------------------- Ice-Cold Jokestar unlock
---------------------------

local ref_evaluate_play = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    local last_hand = G.GAME.last_hand_played
    if G.GAME.current_round.hands_played == 0 and next(SMODS.find_card('c_fnwk_gotequest_sweet')) then
        G.fnwk_sweet_dreams_flag = true
    end
    local ret = ref_evaluate_play(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if math.floor(hand_chips*mult) >= G.GAME.blind.chips then
                G.GAME.fnwk_chip_novas = G.GAME.fnwk_chip_novas + 1
                check_for_unlock({type = 'chip_nova', total_novas = G.GAME.fnwk_chip_novas})
            end
            return true
        end
    }))

    if G.GAME.last_hand_played ~= last_hand then
        G.GAME.fnwk_consecutive_hands = 1
    else
        G.GAME.fnwk_consecutive_hands = G.GAME.fnwk_consecutive_hands + 1
    end
    check_for_unlock({type = 'consecutive_hands', num_consecutive = G.GAME.fnwk_consecutive_hands})

    return ret
end





---------------------------
--------------------------- Type Prime/ACT Deck Unlocks
---------------------------

local ref_win_game = win_game
function win_game(...)
    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        check_for_unlock({type = 'fnwk_win_deck'})
    end

    return ref_win_game(...)
end





---------------------------
--------------------------- Electriclarryland effect
---------------------------

local ref_play_to_discard = G.FUNCS.draw_from_play_to_discard
G.FUNCS.draw_from_play_to_discard = function(e)
    local larrylands = SMODS.find_card('c_fnwk_sunshine_electric')
    if next(larrylands) and G.GAME.current_round.hands_played == 0 then
        local play_count = #G.play.cards
        local it = 1
        for _, v in ipairs(larrylands) do
            local larry_card = v
            ArrowAPI.stands.flare_aura(larry_card, 0.5)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                larry_card:juice_up()
                play_sound('generic1')
                return true end
            }))
            delay(0.2)
        end
        for k, v in ipairs(G.play.cards) do
            if (not v.shattered) and (not v.destroyed) then
                local enhanced = next(SMODS.get_enhancements(v))
                local location = enhanced and G.hand or G.discard
                local face = enhanced and 'up' or 'down'
                draw_card(G.play, location, it*100/play_count, face, enhanced, v)
                it = it + 1
            end
        end
        return
    end

    return ref_play_to_discard(e)
end





---------------------------
--------------------------- Sweet Dreams map
---------------------------

local rank_map = {
    [3] = 'Ace',
    [6] = '2',
    [9] = '3'
}

local ref_poker_hand_info = G.FUNCS.get_poker_hand_info
G.FUNCS.get_poker_hand_info = function(e)
    local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = ref_poker_hand_info(e)
    if G.fnwk_sweet_dreams_flag and #scoring_hand == 1 then
        local rank_key = rank_map[scoring_hand[1]:get_id()]
        if rank_key then
            local main_card = SMODS.change_base(scoring_hand[1], nil, rank_key, true)
            local flip_cards = {main_card}

            local new_cards = {}
            for i=1, 2 do
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local new_copy = copy_card(flip_cards[1], nil, nil, G.playing_card)
                new_copy:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, new_copy)
                table.insert(scoring_hand, new_copy)
                new_copy.states.visible = false
                G.play:emplace(new_copy)

                new_copy.flipping = nil
                new_copy.facing = 'back'
                new_copy.sprite_facing = 'back'
                new_cards[#new_cards+1] = new_copy
                flip_cards[#flip_cards+1] = new_copy
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    flip_cards[1]:flip()
                    play_sound('card1')
                    flip_cards[1]:juice_up(0.3, 0.3)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    flip_cards[1]:set_sprites(nil, flip_cards[1].config.card)
                    for i, v in ipairs(new_cards) do
                        v:start_materialize(nil, i==1)
                        v:juice_up()
                    end
                    return true
                end
            }))

            delay(0.3)

            for i, v in ipairs(flip_cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        v:flip()
                        play_sound('tarot2', 1, 0.6)
                        v:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end

            playing_card_joker_effects(new_cards)
        end
    end
    G.fnwk_sweet_dreams_flag = nil

    return text, disp_text, poker_hands, scoring_hand, non_loc_disp_text
end