local jokerInfo = {
	name = 'The Halves',
	config = {
        extra = {
            final_mult_mod = 0.5
        }
    },
	rarity = 3,
	cost = 10,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'spirit',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = {card.ability.extra.final_mult_mod}}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or context.cardarea ~= G.jokers or card.debuff then
        return
    end

    if context.scoring_name ~= 'Pair' then
        return
    end

    local juice_card = context.blueprint_card or card
    balance_score(juice_card)

    mult = math.floor(mult * card.ability.extra.final_mult_mod)
    update_hand_text({delay = 0}, {mult = mult, chips = hand_chips})

    return {
        message_card = juice_card,
        colour = G.C.MULT,
        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.final_mult_mod}},
    }
end

return jokerInfo