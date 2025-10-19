local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

function achInfo.unlock_condition(self, args)
    return args.type == 'gotequest_city'
end

return achInfo