local achInfo = {
    rarity = 4,
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    local tally = 0
    local total = 0
    for _, v in pairs(G.ACHIEVEMENTS) do
        if v.original_mod and v.original_mod.id == 'fanworks' then
            total = total + 1
            if v.earned then
                tally = tally + 1
            end
        end
    end

    return tally >= total
end

return achInfo