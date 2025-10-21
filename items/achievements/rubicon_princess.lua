local achInfo = {
    rarity = 1,
    config = {key = 'j_fnwk_rubicon_crown', rank = 'Queen', num = 5},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
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
    if args.type ~= 'hand_contents' or not next(SMODS.find_card(self.config.key, true))
    or #args.cards ~= self.config.num then return false end

    local text = G.FUNCS.get_poker_hand_info(args.cards)
    if text ~= 'Five of a Kind' then return false end

    for _, v in ipairs(args.cards) do
        if v.base.value ~= self.config.rank or v.config.center.key ~= 'c_base'
        or v.seal or v.edition then return false end
    end

    return true
end

return achInfo