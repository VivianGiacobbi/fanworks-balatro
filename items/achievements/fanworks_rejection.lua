local achInfo = {
    rarity = 2,
    config = {blind = 'bl_fnwk_final_application'},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {
        G.P_BLINDS[self.config.blind].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.blind} or '?????',
    }}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'round_win' or not G.GAME.blind
    or G.GAME.blind.config.blind.key ~= self.config.blind then return false end

    for _, v in ipairs(G.jokers.cards) do
        if not v.fnwk_work_submitted then return false end
    end

    return G.GAME.current_round.hands_left == 0
end

return achInfo