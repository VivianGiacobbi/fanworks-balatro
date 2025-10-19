local achInfo = {
    rarity = 2,
    config = {free_rolls = 20},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
        custom_color = 'bone',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.free_rolls}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_shop_rerolled' then return false end

    if args.cost == 0 then
        G.GAME.fnwk_smells_rerolls = (G.GAME.fnwk_smells_rerolls or 0) + 1
        return G.GAME.fnwk_smells_rerolls >= self.config.free_rolls
    end
end

return achInfo