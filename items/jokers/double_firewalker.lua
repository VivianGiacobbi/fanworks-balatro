local jokerInfo = {
	name = 'The Firewalker',
	config = {},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'double'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return jokerInfo