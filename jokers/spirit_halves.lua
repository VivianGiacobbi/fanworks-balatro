local jokerInfo = {
    key = 'j_fnwk_spiritlines_halves',
	name = 'The Halves',
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'spirit',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or context.cardarea ~= G.jokers or card.debuff then
        return
    end

    if context.scoring_name ~= 'Pair' then
        return
    end

    balance_score(context.blueprint_card or card)
end

return jokerInfo