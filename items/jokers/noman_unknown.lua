local jokerInfo = {
	name = 'Unknown Soldier',
	config = {
		extra = {
			mult = 0,
			mult_mod = 1,
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'noman',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
end

return jokerInfo