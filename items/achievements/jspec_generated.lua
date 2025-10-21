local achInfo = {
    rarity = 3,
    config = {planets = 10},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.planets}}
end

function achInfo.unlock_condition(self, args)
    if args.type == 'fnwk_seal_planet' then
        G.GAME.fnwk_jspec_seals = (G.GAME.fnwk_jspec_seals or 0) + 1
        if G.GAME.fnwk_jspec_seals >= self.config.planets then
            return true
        end
    end

    if args.type == 'round_win' then
        G.GAME.fnwk_jspec_seals = nil
    end
end

return achInfo