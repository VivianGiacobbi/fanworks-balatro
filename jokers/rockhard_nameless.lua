local jokerInfo = {
	name = 'Trans Am',
	config = {
        extra = {
            mult = 0,
            mult_mod = 1
        }
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
end

function jokerInfo.calculate(self, card, context)

end

return jokerInfo