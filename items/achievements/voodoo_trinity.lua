local achInfo = {
    rarity = 2,
    config = {hand_name = 'Royal Flush', num_consecutive = 3},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'voodoo',
		},
        custom_color = 'voodoo',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num_consecutive, self.config.hand_name}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand' then return false end

    if args.disp_text == self.config.hand_name then
        G.GAME.fnwk_trinity_flush_consecutive = (G.GAME.fnwk_trinity_flush_consecutive or 0) + 1
        return G.GAME.fnwk_trinity_flush_consecutive >= self.config.num_consecutive
    end

    G.GAME.fnwk_trinity_flush_consecutive = 0
end

return achInfo