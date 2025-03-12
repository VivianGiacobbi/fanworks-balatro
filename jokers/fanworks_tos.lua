local jokerInfo = {
	name = 'TOS',
	config = {
        extra = {
            chips = 100
        }
    },
	rarity = 1,
	cost = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_tos", set = "Other"}
    return { vars = { card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
    if not context.individual or not context.cardarea == G.play or card.debuff or context.other_card.debuff then
        return
    end

    if context.other_card:is_suit('Spades') and context.other_card:get_id() == 3 then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo