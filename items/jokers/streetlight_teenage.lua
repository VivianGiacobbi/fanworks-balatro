local jokerInfo = {
	name = 'Teenage Gangster',
	config = {},
	rarity = 1,
	cost = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'streetlight',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.leafy }}
end

return jokerInfo