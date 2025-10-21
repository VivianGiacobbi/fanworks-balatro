local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_moscow_mule', num_cards = 5},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'moscow',
		},
        custom_color = 'moscow',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        self.config.num_cards,
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
    }}
end


function achInfo.unlock_condition(self, args)
    return args.type == 'fnwk_moscow_mixed'
end

return achInfo