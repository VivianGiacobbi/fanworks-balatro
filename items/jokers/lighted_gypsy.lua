local jokerInfo = {
	name = 'Gypsy Eyes',
	config = {
		extra = {
			chance = 3,
			remaining = 5,
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'lighted'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.remaining}}
end

return jokerInfo