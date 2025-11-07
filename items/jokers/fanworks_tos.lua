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
    artist = 'TOS',
    programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) or card.debuff or context.other_card.debuff then
        return
    end

    if context.other_card:is_suit('Spades') and context.other_card:get_id() == 3 then
        return {
            chips = card.ability.extra.chips,
            card = context.other_card
        }
    end
end

return jokerInfo