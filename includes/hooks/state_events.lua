--- Unlock condition used by Corpse Crimelord
local ref_end_round = end_round
function end_round()
    local ret ref_end_round()
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

local ref_evaluate_play = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    local last_hand = G.GAME.last_hand_played
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

local ref_play_to_discard = G.FUNCS.draw_from_play_to_discard
G.FUNCS.draw_from_play_to_discard = function(e)
    local larrylands = SMODS.find_card('c_fnwk_sunshine_electric')
    if (next(larrylands)) and G.GAME.current_round.hands_played == 0 then
        local play_count = #G.play.cards
        local it = 1
        for _, v in ipairs(larrylands) do
            local larry_card = v
            G.FUNCS.csau_flare_stand_aura(larry_card, 0.5)
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