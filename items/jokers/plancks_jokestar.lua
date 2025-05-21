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
            if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
            or next(SMODS.find_card("c_jojobal_steel_tusk_4")))
            or not next(parts.jojobal_fibonacci) then 
                return {} 
            end
            return { hand }
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
            if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
            or next(SMODS.find_card("c_jojobal_steel_tusk_4")))
            or not next(parts.jojobal_fibonacci) then 
                return {} 
            end
            return { SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) }
        end,
    })
end


if not SMODS.PokerHands['jojobal_FlushFibonacci'] then
    SMODS.PokerHand {
        key = 'jojobal_FlushFibonacci',
        prefix_config = false,
        evaluate = function(parts, hand)
            if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
            or next(SMODS.find_card("c_jojobal_steel_tusk_4")))
            or not next(parts.jojobal_fibonacci) or not next(parts._flush) then 
                return {} 
            end
            return { SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) }
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
            if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
            or next(SMODS.find_card("c_jojobal_steel_tusk_4")))
            or not next(parts.jojobal_fibonacci) or not next(parts._flush) then 
                return {} 
            end
            return { SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) }
        end,
    })
end

local jokerInfo = {
    name = 'Creaking Bjokestar',
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.2,
        },
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    fanwork = 'plancks',
    alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.GAME.hands['jojobal_Fibonacci'].visible = true
    G.GAME.hands['jojobal_FlushFibonacci'].visible = true
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if next(SMODS.find_card('j_fnwk_plancks_jokestar')) or next(SMODS.find_card("c_jojobal_steel_tusk_4")) then
        return
    end
    G.GAME.hands['jojobal_Fibonacci'].visible = false
    G.GAME.hands['jojobal_FlushFibonacci'].visible = false
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then

        if not next(context.poker_hands['Fibonacci']) then
            return
        end
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod	
        return {
            message = localize('k_upgrade_ex'),
            card = card,
        }
    end
	if context.joker_main and context.cardarea == G.jokers and not card.debuff and card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end
end

return jokerInfo