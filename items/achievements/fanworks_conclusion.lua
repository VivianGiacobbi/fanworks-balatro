local achInfo = {
    rarity = 4,
    config = {stake = 8},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {
        localize{type = 'name_text', key = SMODS.stake_from_index(self.config.stake), set = 'Stake'},
        colours = {get_stake_col(self.config.stake)}
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'win_stake' then return false end

    local tally = 0
    local total = 0
    for _, v in pairs(G.P_CENTERS) do
        if v.set == 'Back' and not v.omit  and v.original_mod and v.original_mod.id == 'fanworks' and not v.no_collection then
            total = total + #G.P_CENTER_POOLS.Stake
            tally = tally + get_deck_win_stake(v.key)
        end
    end

    return tally >= total
end

return achInfo