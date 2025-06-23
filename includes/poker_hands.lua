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

			return { fnwk_has_valid_fib_card() and hand or nil }
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
else
    -- otherwise just update the evaluate condition to include the check for Bjorn
    SMODS.PokerHand:take_ownership('jojobal_Fibonacci', {
        evaluate = function(parts, hand)
            if not next(parts.jojobal_fibonacci) then 
                return {}
            end
			
			return { fnwk_has_valid_fib_card() and hand or nil }
        end,
    })
end


if not SMODS.PokerHands['jojobal_FlushFibonacci'] then
    SMODS.PokerHand {
        key = 'jojobal_FlushFibonacci',
        prefix_config = false,
        evaluate = function(parts, hand)
            if not next(parts.jojobal_fibonacci) or not next(parts._flush) then
                return {} 
            end

            return { fnwk_has_valid_fib_card() and SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) or nil }
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
else
    -- otherwise just update the evaluate condition to include the check for Bjorn
    SMODS.PokerHand:take_ownership('jojobal_FlushFibonacci', {
        evaluate = function(parts, hand)
            if not next(parts.jojobal_fibonacci) or not next(parts._flush) then
                return {}
            end
			
			return { fnwk_has_valid_fib_card() and SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) or nil }
        end,
    })
end