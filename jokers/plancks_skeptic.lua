local jokerInfo = {
	name = 'Skeptic Creaking Joker',
	config = {},
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = "plancks",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
end

return jokerInfo