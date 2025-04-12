local jokerInfo = {
	name = 'Morse Tapping',
	config = {
		extra = {
			ranks = 2,
			x_mult = 2,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'last',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.x_mult, card.ability.extra.ranks}}
end

return jokerInfo