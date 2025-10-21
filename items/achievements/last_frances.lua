local achInfo = {
    rarity = 1,
    config = { key = 'j_fnwk_last_morse', consec_triggers = 2 },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'last',
		},
        custom_color = 'last',
    },
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
        self.config.consec_triggers
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type == 'chip_score' then
        if not G.GAME.fnwk_morse_last_flag then
            G.GAME.fnwk_morse_triggers = 0
        end

        G.GAME.fnwk_morse_last_flag = nil
        G.GAME.fnwk_morse_checked_flag = nil
        return false
    end

    if args.type ~= 'fanworks_triggered' then return false end

    if args.triggered.key == 'j_fnwk_last_morse' and not G.GAME.fnwk_morse_checked_flag then
        G.GAME.fnwk_morse_last_flag = true
        G.GAME.fnwk_morse_checked_flag = true
        G.GAME.fnwk_morse_triggers = (G.GAME.fnwk_morse_triggers or 0) + 1
        return G.GAME.fnwk_morse_triggers >= self.config.consec_triggers
    end
end

return achInfo