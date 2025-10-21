local achInfo = {
    rarity = 1,
    config = {blind = 'bl_fnwk_box', enhancement = 'm_steel', num = 5},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {
        self.config.num,
        localize{type = 'name_text', set = 'Enhanced', key = self.config.enhancement},
        G.P_BLINDS[self.config.blind].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.blind} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand_contents' or #args.cards ~= self.config.num
    or not G.GAME.blind or G.GAME.blind.config.blind.key ~= self.config.blind then return false end

    for _, v in ipairs(args.cards) do
        if v.config.center.key ~= self.config.enhancement then return false end
    end

    return true
end

return achInfo