local achInfo = {
    rarity = 2,
    config = {key_1 = 'j_fnwk_iron_sanctuary', key_2 = 'j_fnwk_iron_boney'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'iron',
		},
        custom_color = 'iron',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '?????',
            G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '?????',
        }
    }
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_iron_strangers'
end

return achInfo