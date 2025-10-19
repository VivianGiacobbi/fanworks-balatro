local achInfo = {
    rarity = 2,
    config = {triggers = 10},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.triggers}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fanworks_triggered' then return false end

    if not G.GAME.fnwk_foty_triggers then
        G.GAME.fnwk_foty_triggers = { count = 0 }
    end

    if not G.GAME.fnwk_foty_triggers[args.triggered.origin.sub_origins[1]] then
        G.GAME.fnwk_foty_triggers[args.triggered.origin.sub_origins[1]] = true
        G.GAME.fnwk_foty_triggers.count = G.GAME.fnwk_foty_triggers.count + 1
        return G.GAME.fnwk_foty_triggers.count >= self.config.triggers
    end
end

return achInfo