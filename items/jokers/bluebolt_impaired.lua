local jokerInfo = {
	name = 'Impaired Joker',
	config = {
        extra = {
			x_mult = 1.5,
		}
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return {vars = {card.ability.extra.x_mult}}
end

return jokerInfo