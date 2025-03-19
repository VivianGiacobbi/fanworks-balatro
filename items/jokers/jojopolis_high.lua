local jokerInfo = {
	name = 'From On High',
	config = {},
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jojopolis'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return jokerInfo