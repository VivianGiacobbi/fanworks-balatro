local jokerInfo = {
	name = 'Joker Von Bronx',
	config = {
        extra = {
            dollars = 6,
        },
    },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'lipstick'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
    return { vars = {card.ability.extra.dollars}}
end

function jokerInfo.calculate(self, card, context)
    
    if not (context.remove_playing_cards and context.cardarea == G.jokers) or card.debuff then
        return
    end

    local dollars = card.ability.extra.dollars * #context.removed
    return {
        dollars = dollars,
        card = context.blueprint_card or card
    }
end

return jokerInfo