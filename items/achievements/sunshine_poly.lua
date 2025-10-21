local achInfo = {
    rarity = 2,
    config = {blind = 'bl_eye'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_BLINDS[self.config.blind].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.blind} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    if JoJoFanworks.current_config['enable_BlindReskins'] then return false end

    if args.type == 'hand_contents' then
        local text, _, _,scoring_hand = G.FUNCS.get_poker_hand_info(args.cards)
        if text ~= 'Pair' then
            G.GAME.fnwk_valid_poly_hand = nil
            return false
        end

        local c1 = scoring_hand[1]
        local c2 = scoring_hand[1]
        if c1.base.suit == c2.base.suit and c1.base.value == c2.base.value
        and c1.config.center.key == c2.config.center.key and c1.seal == c2.seal
        and c1.edition == c2.edition then
            G.GAME.fnwk_valid_poly_hand = true
            return false
        end

        G.GAME.fnwk_valid_poly_hand = nil
        return false
    end

    return args.type == 'round_win' and G.GAME.blind.config.blind.key == self.config.blind and G.GAME.fnwk_valid_poly_hand
end

return achInfo