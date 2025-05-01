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
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
    return { vars = { card.ability.extra, math.max(0, card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)), G.GAME.starting_deck_size } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0) > 0 then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)}},
			mult_mod = card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size)), 
            card = context.blueprint_card or card
		}
	end
end

return jokerInfo