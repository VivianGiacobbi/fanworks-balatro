local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'redrising',
		},
        custom_color = 'redrising',
    },
}

function achInfo.unlock_condition(self, args)
    return args.type == 'redrising_found'
end

return achInfo