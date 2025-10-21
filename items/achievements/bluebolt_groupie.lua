local achInfo = {
    rarity = 3,
    config = {main_key = 'j_fnwk_bluebolt_sexy', num_women = 7},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
        custom_color = 'bluebolt',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.main_key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.main_key} or '?????',
            self.config.num_women - 1
        }
    }
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_added' then return false end

    local women = 0
    local has_sexy = false
    for i=1, #G.jokers.cards + 1 do
        local key = i == (#G.jokers.cards + 1) and args.card.config.center.key or G.jokers.cards[i].config.center.key
        has_sexy = has_sexy or key == self.config.main_key
        local added_woman = G.fnwk_women.get_from_key(key)
        if added_woman.trans or added_woman.woman then
            women = women + 1
        end
    end

    return has_sexy and women >= self.config.num_women
end

return achInfo