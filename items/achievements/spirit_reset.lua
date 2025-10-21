local achInfo = {
    rarity = 3,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_won_with_jokers' or not G.PROFILES[G.SETTINGS.profile].last_win_jokers then return false end

    local last_win_jokers = copy_table(G.PROFILES[G.SETTINGS.profile].last_win_jokers)
    for _, v in ipairs(G.jokers.cards) do
        if not next(last_win_jokers) then return false end

        if last_win_jokers[v.config.center.key] then
            last_win_jokers[v.config.center.key] = nil
        end
    end

    return not next(last_win_jokers)
end

return achInfo