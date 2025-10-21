local achInfo = {
    rarity = 4,
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'win_challenge' then return false end

    local tally = 0
    local total = 0
    for _, v in pairs(G.CHALLENGES) do
        if v.original_mod and v.original_mod.id == 'fanworks' then
            total = G.PROGRESS.challenges.of + 1
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id] then
                tally = tally + 1
            end
        end
    end

    return tally >= total
end

return achInfo