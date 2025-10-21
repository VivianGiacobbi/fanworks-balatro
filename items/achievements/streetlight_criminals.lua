local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_fnwk_streetlight_teenage', key_2 = 'c_fnwk_streetlight_notorious'},
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
    if args.type ~= 'fnwk_card_added' then return false end

    local has_teenage = args.card.config.center.key == self.config.key_1
    local has_notorious = args.card.config.center.key == self.config.key_2
    if not has_teenage then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == self.config.key_1 then
                has_teenage = true
                break
            end
        end
    end

    if not has_notorious then
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == self.config.key_2 then
                has_notorious = true
                break
            end
        end
    end

    return has_teenage and has_notorious
end

return achInfo