local achInfo = {
    rarity = 2,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
}

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_streetlight_daddy'
end

return achInfo