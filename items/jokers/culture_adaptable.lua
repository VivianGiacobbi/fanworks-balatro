local jokerInfo = {
	name = 'Adaptable Jokestar',
	config = {
        extra = 2
    },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'culture',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.shaft }}
    return { vars = {card.ability.extra, fnwk_get_enhanced_tally() * card.ability.extra}}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or not context.cardarea == G.jokers or card.debuff then
        return
    end

    local enhanced = fnwk_get_enhanced_tally()
    if enhanced > 0 then
        return {
            message = localize { type = 'variable', key = 'a_mult', vars = {enhanced * card.ability.extra} },
            mult_mod = enhanced * card.ability.extra,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo