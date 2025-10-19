local achInfo = {
    rarity = 1,
    config = {enhancements = 8},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.enhancements}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'modify_deck' then return false end

    local enhance_map = {}
    local count = 0
    for _, v in ipairs(G.playing_cards) do
        if v.config.center.key ~= 'c_base' and not enhance_map[v.config.center.key] then
            enhance_map[v.config.center.key] = true
            count = count + 1
            if count >= self.config.enhancements then return true end
        end
    end
end

return achInfo