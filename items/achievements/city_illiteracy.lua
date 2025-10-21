local achInfo = {
    rarity = 1,
    config = {key = 'j_fnwk_city_neet'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'city',
		},
        custom_color = 'city',
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
    if args.type ~= 'fnwk_card_added' or not next(SMODS.find_card(self.config.key)) then return false end

    local name = string.lower(args.card.config.center.name)
    return string.find(name, 'joker') or string.find(name, 'jokestar')
end

return achInfo