local achInfo = {
    rarity = 2,
    config = {blind = 'bl_fnwk_final_multimedia'},
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

    local suits_map = {}
    local num_suits = 0
    for _, v in ipairs(G.playing_cards) do
        if not suits_map[v.base.suit] then
            suits_map[v.base.suit] = true
            num_suits = num_suits + 1
            if num_suits > 1 then return false end
        end
    end

    return true
end

return achInfo