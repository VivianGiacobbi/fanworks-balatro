local achInfo = {
    rarity = 1,
    config = {positions = 5},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {vars = {self.config.positions}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand_contents' then return false end

    G.GAME.fnwk_hand_positions = G.GAME.fnwk_hand_positions or {{}, {}, {}, {}, {}}
    for i, v in ipairs(args.cards) do
        if not G.GAME.fnwk_hand_positions[i] then
            G.GAME.fnwk_hand_positions[i] = {}
        end
        G.GAME.fnwk_hand_positions[i][v.fnwk_id] = true
    end

    local position_count = {}
    for i, v in ipairs(G.GAME.fnwk_hand_positions) do
        for k, _ in pairs(v) do
            position_count[k] = (position_count[k] or 0) + 1
            if position_count[k] >= self.config.positions then
                return true
            end
        end
    end
end

return achInfo