local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_run_loss' then return false end

    return G.GAME.current_round.hands_left > 0 and G.GAME.current_round.discards_left > 0
end

return achInfo