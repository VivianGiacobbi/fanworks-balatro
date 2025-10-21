local achInfo = {
    rarity = 2,
    config = {key_1 = 'j_fnwk_streetlight_arrow', key_2 = 'c_fnwk_streetlight_paperback'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '?????',
            G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Stand', key = self.config.key_2} or '?????',
        }
    }
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_sold'
    or args.card.config.center.key ~= self.config.key_1 then return false end

    local stand = ArrowAPI.stands.get_leftmost_stand()
    return stand and stand.config.center.key == self.config.key_2
end

return achInfo