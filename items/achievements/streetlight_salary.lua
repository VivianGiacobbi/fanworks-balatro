local achInfo = {
    rarity = 1,
    config = {key = 'j_fnwk_streetlight_industrious'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
}

function achInfo.loc_vars(self)
    return {key = self.key..(G.P_CENTERS[self.config.key].discovered and '_alt' or '')}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_biased_woman' then return false end

    return args.new_card.config.center.key == self.config.key
end

return achInfo