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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'culture',
		},
        custom_color = 'culture',
    },
    artist = 'shaft',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, ArrowAPI.game.get_enhanced_tally() * card.ability.extra}}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or not context.cardarea == G.jokers or card.debuff then
        return
    end

    local enhanced = ArrowAPI.game.get_enhanced_tally()
    if enhanced > 0 then
        return {
            mult = enhanced * card.ability.extra,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo