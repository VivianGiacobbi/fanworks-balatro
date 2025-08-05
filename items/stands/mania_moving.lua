local consumInfo = {
    name = 'Moving Pictures',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FDD48EDC', 'EEBA64DC' },
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'mania',
		},
        custom_color = 'mania',
    },
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo