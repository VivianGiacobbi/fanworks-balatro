local jokerInfo = {
	name = 'Corpse Part',
	config = {
        x_mult = 4,
        extra = {
            effect = {}
        }
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	no_collection = true,
	fanwork = 'spirit',
}

function jokerInfo.in_pool(self, args)
    return false
end


return jokerInfo