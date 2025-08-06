local jokerInfo = {
	name = 'aJOreKEsR',
	config = {
		extra = {
			rank_id = 8,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	hasSoul = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'gote',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.rank_id}}
end

return jokerInfo