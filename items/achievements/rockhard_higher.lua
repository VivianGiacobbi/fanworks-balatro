local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_rockhard_numbers'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_rockhard_higher'
end

return achInfo