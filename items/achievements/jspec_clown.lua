local achInfo = {
    rarity = 3,
    config = {key_1 = 'j_fnwk_jspec_joepie', key_2 = 'j_fnwk_jspec_kunst', key_3 = 'j_fnwk_jspec_ilsa', },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        localize{type = 'name_text', set = 'Joker', key = self.config.key_1},
        localize{type = 'name_text', set = 'Joker', key = self.config.key_2},
        localize{type = 'name_text', set = 'Joker', key = self.config.key_3},
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'discover_amount' then return false end

    return G.P_CENTERS[self.config.key_1].discovered
    and G.P_CENTERS[self.config.key_2].discovered and G.P_CENTERS[self.config.key_3].discovered
end

return achInfo