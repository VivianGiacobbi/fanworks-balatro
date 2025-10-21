local achInfo = {
    rarity = 3,
    config = {survives = 3},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.survives}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'saved_from_death' then return false end

    G.GAME.fnwk_death_saves = (G.GAME.fnwk_death_saves or 0) + 1
    return G.GAME.fnwk_death_saves >= self.config.survives
end

return achInfo