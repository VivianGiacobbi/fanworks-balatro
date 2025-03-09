SMODS.PokerHandPart {
    key = 'fibonacci',
    func = function(hand) 
        return get_fibonacci(hand) 
    end,
}

SMODS.PokerHand {
    key = 'fibonacci',
    evaluate = function(parts, hand)
        if not next(SMODS.find_card('j_fnwk_plancks_jokestar')) or not next(parts.fnwk_fibonacci) then return {} end
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

SMODS.PokerHand {
    key = 'flush_fib',
    evaluate = function(parts, hand)
        if not next(SMODS.find_card('j_fnwk_plancks_jokestar')) or not next(parts.fnwk_fibonacci) or not next(parts._flush) then return {} end
        return { SMODS.merge_lists(parts.fnwk_fibonacci, parts._flush) }
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

local jokerInfo = {
    key = 'j_fnwk_plancks_jokestar',
    name = 'Creaking Bjokestar',
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.2,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'plancks',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.GAME.hands['fnwk_fibonacci'].visible = true
    G.GAME.hands['fnwk_flush_fib'].visible = true
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if next(SMODS.find_card('j_fnwk_plancks_jokestar')) then
        return
    end
    G.GAME.hands['fnwk_fibonacci'].visible = false
    G.GAME.hands['fnwk_flush_fib'].visible = false
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then

        if not (context.scoring_name == 'fnwk_fibonacci' or context.scoring_name == 'fnwk_flush_fib') then
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