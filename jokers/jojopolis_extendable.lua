local jokerInfo = {
	name = 'Extendable Jokestar',
	config = {
		extra = 2
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jojopolis'
}

function jokerInfo.loc_vars(self, info_queue, card)

    return { vars = {
            card.abiliy.extra,
            math.max(0, card.ability.extra * (G.playing_cards and #G.playing_cards - G.GAME.starting_deck_size or 0)),
            G.GAME.starting_deck_size
        }
    }
end

function jokerInfo.calculate(self, card, context)

end

return jokerInfo