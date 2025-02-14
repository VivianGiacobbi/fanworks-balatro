local jokerInfo = {
    name = 'Extendable Jokestar',
    config = {
        extra = 2
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'jojopolis',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
    return { vars = { card.ability.extra, math.max(0, card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)), G.GAME.starting_deck_size } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)) > to_big(0) then
		return {
			message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))}},
			mult_mod = card.ability.extra, 
		}
	end
end

return jokerInfo