local jokerInfo = {
    key = 'j_fnwk_spirit_halves',
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
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
    return { vars = {card.ability.extra.final_mult_mod}}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or context.cardarea ~= G.jokers or card.debuff then
        return
    end

    if context.scoring_name ~= 'Pair' then
        return
    end


    return {
        balance = true,
        card = context.blueprint_card or card,
        delay = 0.7,
        extra = {
            x_mult = card.ability.extra.final_mult_mod,
            message_card = context.blueprint_card or card,
        }
    }
end

return jokerInfo