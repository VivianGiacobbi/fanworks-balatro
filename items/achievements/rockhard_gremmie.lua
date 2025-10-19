local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'modify_deck' or #G.playing_cards == 0 then return false end

    for _, v in pairs(G.playing_cards) do
        if not SMODS.has_no_suit(v) and not SMODS.has_any_suit(v) then return false end
    end

    return true
end

return achInfo