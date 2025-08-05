local consumInfo = {
    name = 'Sweet Dreams',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            play_ranks = {'3', '6', '9'},
            convert_ranks = {'A', '2', '3'}
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'glass',
		},
        custom_color = 'glass',
    },
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.play_ranks[1],
            card.ability.extra.play_ranks[2],
            card.ability.extra.play_ranks[3],
            card.ability.extra.convert_ranks[1],
            card.ability.extra.convert_ranks[2],
            card.ability.extra.convert_ranks[3]
        }
    }
end

function consumInfo.calculate(self, card, context)

end

return consumInfo