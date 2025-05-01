local jokerInfo = {
	name = 'Arrow Shard',
	config = {},
	rarity = 3,
	cost = 10,
	blueprint_compat = false,
	eternal_compat = false,
	perishable = true,
	fanwork = 'streetlight',
	in_progress = true,
	required_stands = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.leafy }}
end

return jokerInfo