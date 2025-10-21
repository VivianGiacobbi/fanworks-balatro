local achInfo = {
    rarity = 2,
    config = {blind = 'bl_fnwk_written', hand = 'Flush'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'mania',
		},
        custom_color = 'mania',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_BLINDS[self.config.blind].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.blind} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand_contents' or not G.GAME.blind
    or G.GAME.blind.config.blind.key ~= self.config.blind then return false end

    local text = G.FUNCS.get_poker_hand_info(args.cards)

    return text == self.config.hand
end

return achInfo