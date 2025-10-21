local achInfo = {
    rarity = 3,
    config = {ante = 16},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.ante}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'round_win' then return false end

    local deck = G.GAME.selected_back.effect.center
    if not deck.original_mod or deck.original_mod.id ~= 'fanworks' then return false end

    return G.GAME.blind:get_type() == 'Boss' and G.GAME.round_resets.ante >= self.config.ante
end

return achInfo