
local jokerInfo = {
	name = 'Crown of Thorns',
	config = {},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rubicon',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cream", set = "Other"}
end

return jokerInfo