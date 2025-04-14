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
    for k, v in pairs(hands) do
        level_up_hand(card, k, true, amount)
    end
    SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = hands, amount = amount})
end