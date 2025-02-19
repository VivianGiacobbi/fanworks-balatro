local jokerInfo = {
	name = 'Moscow Mule',
	config = {},
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = "moscow",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_poul", set = "Other"}
end


return jokerInfo