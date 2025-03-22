local jokerInfo = {
	name = '2HOT2HANDLE',
	config = {},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'gotequest'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return jokerInfo