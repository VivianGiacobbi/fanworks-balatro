local achInfo = {
    rarity = 1,
    config = {enhancement = 'm_steel', num = 5},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num, self.config.enhancement}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand_contents' or #args.cards ~= self.config.num then return false end

    for _, v in ipairs(args.cards) do
        if v.config.center.key ~= self.config.enhancement then return false end
    end

    return true
end

return achInfo