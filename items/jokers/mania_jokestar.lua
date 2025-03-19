local jokerInfo = {
	name = 'Cubist Jokestar',
	config = {
		extra = {
			chance = 2,
			chips = 13,
			mult = 12
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'mania'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.chips, card.ability.extra.mult}}
end

return jokerInfo