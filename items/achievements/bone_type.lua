local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_bone_destroyer'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
        custom_color = 'bone',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.key} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_bone_type'
end

return achInfo