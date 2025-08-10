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
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojopolis',
		},
        custom_color = 'jojopolis',
    },
    artist = 'gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra, math.max(0, card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)), G.GAME.starting_deck_size } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0) > 0 then
		return {
			mult = card.ability.extra*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size)),
            card = context.blueprint_card or card
		}
	end
end

return jokerInfo