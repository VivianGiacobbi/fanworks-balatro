local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_love_jokestar'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'love',
		},
        custom_color = 'love',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_love_nevada'
end

return achInfo