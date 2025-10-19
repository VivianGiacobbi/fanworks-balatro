local achInfo = {
    rarity = 1,
    config = {fails = 20},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.fails}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_rand_result' then return false end

    if not args.result then
        G.GAME.fnwk_tobad_chance_fails = (G.GAME.fnwk_tobad_chance_fails or 0) + 1
        return G.GAME.fnwk_tobad_chance_fails >= self.config.fails
    end

    G.GAME.fnwk_tobad_chance_fails = 0
end

return achInfo