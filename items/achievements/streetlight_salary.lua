local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_biased_woman' then return false end

    return args.new_card.config.center.key == 'j_fnwk_streetlight_industrious'
end

return achInfo