local jokerInfo = {
	name = 'Fragile Joker',
	config = {},
	rarity = 3,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'mania'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return jokerInfo