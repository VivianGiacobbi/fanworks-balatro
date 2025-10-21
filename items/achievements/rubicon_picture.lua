local achInfo = {
    rarity = 3,
    config = {key = 'j_fnwk_rubicon_thnks', chips = 1000},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
            self.config.chips
        }
    }
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_rubicon_picture'
end

return achInfo