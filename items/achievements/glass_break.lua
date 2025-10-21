local achInfo = {
    rarity = 2,
    config = {enhancement_1 = 'm_glass', suit_1 = 'Hearts', enhancement_2 = 'm_stone'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'glass',
		},
        custom_color = 'glass',
    },
}

function achInfo.loc_vars(self)
    local enhance_1 = localize{type = 'name_text', set = 'Enhanced', key = self.config.enhancement_1}
    return {
        vars = {
            localize{type = 'name_text', set = 'Enhanced', key = self.config.enhancement_2},
            string.sub(enhance_1, 1, #enhance_1 - 5),
            localize(self.config.suit_1, 'suits_singular'),
            colours = {G.C[self.config.suit_1]}
        }
    }
end

function achInfo.unlock_condition(self, args)
    if args.type == 'hand_contents' then
        local card_1 = false
        local card_2 = false
        for _, v in ipairs(args.cards) do
            if v.config.center.key == self.config.enhancement_1 and v:is_suit(self.config.suit_1) then
                card_1 = true
            elseif v.config.center.key == self.config.enhancement_2 then
                card_2 = true
            end

            if card_1 and card_2 then
                G.GAME.fnwk_valid_break_hand = true
                return
            end
        end

        G.GAME.fnwk_valid_break_hand = nil
        return
    end

    return args.type == 'round_win' and G.GAME.blind:get_type() == 'Boss' and G.GAME.fnwk_valid_break_hand
end

return achInfo