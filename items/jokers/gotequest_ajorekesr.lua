local jokerInfo = {
	name = 'aJOreKEsR',
	config = {
		extra = {
			rank_id = 8,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'gotequest'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.rank_id}}
end

return jokerInfo