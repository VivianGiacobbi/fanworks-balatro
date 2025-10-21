local achInfo = {
    rarity = 2,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojopolis',
		},
        custom_color = 'jojopolis',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'modify_deck' or #G.playing_cards < 1 then return false end

    for _, v in ipairs(G.playing_cards) do
        if (v.fnwk_id or 0) <= G.GAME.starting_deck_size then return false end
    end

    return true
end

return achInfo