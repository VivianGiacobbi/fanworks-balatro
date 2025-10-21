local achInfo = {
    rarity = 3,
    config = {ante = 9},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.ante}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'chip_score' then return false end

    return args.chips >= G.E_SWITCH_POINT and G.GAME.round_resets.ante < self.config.ante
end

return achInfo