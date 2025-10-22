local consumInfo = {
    name = 'Sweet Dreams',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '28D8C0DC', '9BFEF0DC' },
        extra = {
            rank_map = {
                [3] = 'Ace',
                [6] = '2',
                [9] = '3'
            },
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
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

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { 3, 6, 9, card.ability.extra.rank_map[3], card.ability.extra.rank_map[6], card.ability.extra.rank_map[9] } }
end

return consumInfo