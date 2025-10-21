local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_sunshine_laconic', chips = 20},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
        self.config.chips
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_laconic_reset' then return end

    return args.chips >= self.config.chips
end

return achInfo