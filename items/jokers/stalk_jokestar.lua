local jokerInfo = {
	name = 'Investigative Jokestar',
	config = {
		extra = {
			mult = 20,
			chips = 100
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'stalk',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

return jokerInfo