local consumInfo = {
    name = 'BORN 2B WILD',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            ranks = {'2', '5', '8', 'Jack', 'Ace'}
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
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.ranks[1],
            card.ability.extra.ranks[2],
            card.ability.extra.ranks[3],
            card.ability.extra.ranks[4],
            card.ability.extra.ranks[5]
        }
    }
end

function consumInfo.calculate(self, card, context)

end

return consumInfo