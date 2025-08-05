local consumInfo = {
    name = 'Takyon',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            start_rank = '2',
            current_rank = '2',
            x_mult = 2
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
    return { vars = {card.ability.extra.current_rank, card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo