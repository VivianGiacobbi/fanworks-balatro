local achInfo = {
    rarity = 2,
    config = {key = 'c_fnwk_crimson_fortunate'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Stand', key = self.config.key} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_crimson_american'
end

return achInfo