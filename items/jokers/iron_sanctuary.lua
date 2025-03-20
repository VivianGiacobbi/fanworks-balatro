local jokerInfo = {
	name = 'Sanctuary City',
	config = {
		extra = {
			rank_id = 9,
			mult = 9
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'iron'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = { card.ability.extra.rank_id, card.ability.extra.mult}}
end

return jokerInfo