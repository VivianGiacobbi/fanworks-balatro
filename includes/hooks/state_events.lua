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
                G.GAME.chip_novas = G.GAME.chip_novas + 1
                check_for_unlock({type = 'chip_nova', total_novas = G.GAME.chip_novas})
            end
            return true 
        end
    }))

    if G.GAME.last_hand_played ~= last_hand then
        G.GAME.consecutive_hands = 1
    else 
        G.GAME.consecutive_hands = G.GAME.consecutive_hands + 1
    end
    check_for_unlock({type = 'consecutive_hands', num_consecutive = G.GAME.consecutive_hands})

    return ret
end