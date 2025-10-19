local achInfo = {
    rarity = 1,
    config = { hand_size = 4 },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojojidai',
		},
        custom_color = 'jojojidai',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.hand_size}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'min_hand_size'
    or not next(SMODS.find_card('j_fnwk_jojojidai_soldiers')) then return false end

    return G.hand and G.hand.config.card_limit <= self.config.hand_size
end

return achInfo