local achInfo = {
    rarity = 2,
    config = {blind = 'bl_fnwk_final_moe'},
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

    for _, blind_key in ipairs(G.GAME.blind.fnwk_moe_bosses) do
        if blind_key == 'bl_wall' then return true end
    end
end

return achInfo