local achInfo = {
    rarity = 1,
    config = {key = 'j_fnwk_gotequest_killing'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
        }
    }
end


function achInfo.unlock_condition(self, args)
    return args.type == 'gotequest_itgoes'
end

return achInfo