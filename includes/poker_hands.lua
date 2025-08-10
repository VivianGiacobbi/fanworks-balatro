local ref_hand_visible = SMODS.is_poker_hand_visible
function SMODS.is_poker_hand_visible(handname)
    if handname == 'jojobal_Fibonacci' or handname == 'jojobal_FlushFibonacci' then
        local fib_valid = next(SMODS.find_card('j_fnwk_plancks_jokestar')) or next(SMODS.find_card('c_fnwk_plancks_moon'))
		return fib_valid and (handname == 'jojobal_Fibonacci' or G.GAME.hands[handname].played > 0)
	end

	return ref_hand_visible(handname)
end

if not SMODS.PokerHandParts['jojobal_fibonacci'] then
    SMODS.PokerHandPart {
        key = 'jojobal_fibonacci',
        prefix_config = false,
        func = function(hand)
            return jojobal_get_fibonacci(hand)
        end,
    }
end

if not SMODS.PokerHands['jojobal_Fibonacci'] then
    SMODS.PokerHand {
        key = 'jojobal_Fibonacci',
        prefix_config = false,
        evaluate = function(parts, hand)
            if not next(parts.jojobal_fibonacci) then
                return {}
            end

			return { SMODS.is_poker_hand_visible('jojobal_Fibonacci') and hand or nil }
        end,
        example = {
            {'S_A', true},
            {'D_8', true},
            {'D_5', true},
            {'C_3', true},
            {'S_2', true},
        },
        mult = 6,
        l_mult = 3,
        chips = 45,
        l_chips = 25,
        visible = false,
    }
end


if not SMODS.PokerHands['jojobal_FlushFibonacci'] then
    SMODS.PokerHand {
        key = 'jojobal_FlushFibonacci',
        prefix_config = false,
        evaluate = function(parts, hand)
            if not next(parts.jojobal_fibonacci) or not next(parts._flush) then
                return {}
            end

            return { SMODS.is_poker_hand_visible('jojobal_Fibonacci')
            and SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) or nil }
        end,
        example = {
            {'H_A', true},
            {'H_8', true},
            {'H_5', true},
            {'H_3', true},
            {'H_2', true},
        },
        mult = 15,
        l_mult = 4,
        chips = 150,
        l_chips = 45,
        visible = false,
    }
end