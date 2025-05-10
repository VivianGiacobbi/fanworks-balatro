function fnwk_reset_funkadelic()
    G.GAME.fnwk_current_funky_suits = {'Spades', 'Hearts'}
    local suits = {'Spades','Hearts','Clubs','Diamonds'}
    local firstIdx = math.floor(pseudorandom('funk'..G.GAME.round_resets.ante) * 4) + 1
    G.GAME.fnwk_current_funky_suits[1] = suits[firstIdx]
    table.remove(suits, firstIdx)
    G.GAME.fnwk_current_funky_suits[2] = pseudorandom_element(suits, pseudoseed('funk'..G.GAME.round_resets.ante))
end

function fnwk_reset_loyal()
    G.GAME.fnwk_current_loyal_suit = {'Spades'}
    local suits = {'Spades','Hearts','Clubs','Diamonds'}
    local firstIdx = math.floor(pseudorandom('abby'..G.GAME.round_resets.ante) * 4) + 1
    G.GAME.fnwk_current_loyal_suit = suits[firstIdx]
end

function fnwk_reset_infidel()

    local suits = {'Spades','Hearts','Clubs','Diamonds'}
    local j, temp
	for i = #suits, 1, -1 do
		j = math.floor(pseudorandom('infidel'..G.GAME.round_resets.ante) * #suits) + 1
		temp = suits[i]
		suits[i] = suits[j]
		suits[j] = temp
	end

    G.GAME.fnwk_infidel_suits= {
        [suits[1]] = true,
        [suits[2]] = true,
    }
end

function fnwk_batch_level_up(card, hands, amount)
    amount = amount or 1
    G.GAME.fnwk_last_upgraded_hand = {}
    for k, v in pairs(hands) do
        level_up_hand(card, k, true, amount, true)
        G.GAME.fnwk_last_upgraded_hand[k] = true
    end
    SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = hands, amount = amount})
end

local ref_level_up_hand = level_up_hand
function level_up_hand(card, hand, instant, amount, bypass_event)
    local ret = ref_level_up_hand(card, hand, instant, amount)

    if not bypass_event then
        G.GAME.fnwk_last_upgraded_hand = {[hand] = true}
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = {hand}, amount = amount})
                return true
            end
        }))
    end
    
    return ret
end


-- force not using main_start and main_end from default uibox_ability_table function if you've overwritten them
local ref_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if not full_UI_table then
        if _c.loc_vars and type(_c.loc_vars) == 'function' then
            main_start = nil
            main_end = nil
        end
    end

    return ref_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
end