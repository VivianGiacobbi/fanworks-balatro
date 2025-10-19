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
    if args.type ~= 'chip_score' or not JoJoFanworks.current_config['enable_BlindReskins'] then return end

    return G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_final_bell' and args.chips >= G.GAME.blind.chips
end

return achInfo