local jokerInfo = {
	name = 'Headlong Flight',
	config = {
		extra = {
			hand_trigger = 1,
			discard_trigger = 0,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'gotequest'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.hand_trigger, card.ability.extra.discard_trigger}}
end

return jokerInfo