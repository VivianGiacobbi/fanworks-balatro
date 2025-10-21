local achInfo = {
    rarity = 2,
    config = {key = 'j_fnwk_lighted_square'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'lighted',
		},
        custom_color = 'lighted',
    },
}

function achInfo.loc_vars(self)
    return {vars = {localize{type = 'name_text', set = 'Joker', key = self.config.key}}}
end

function achInfo.unlock_condition(self, args)
    if args.type == 'fnwk_card_added' and args.card.config.center.key == self.config.key then
        if not G.GAME.fnwk_herring_flag then
            G.GAME.fnwk_herring_flag = 1
            return false
        end

        return G.GAME.fnwk_herring_flag == 2
    end

    if args.type == 'fnwk_card_removed' and G.GAME.fnwk_herring_flag == 1
    and args.card.config.center.key == self.config.key then
        G.GAME.fnwk_herring_flag = 2
        return false
    end
end

return achInfo