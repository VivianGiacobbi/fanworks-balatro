local jokerInfo = {
	name = 'Will of One',
	config = {
		extra = {
			chips = 0,
			chip_mod = 1,
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'gotequest',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

return jokerInfo