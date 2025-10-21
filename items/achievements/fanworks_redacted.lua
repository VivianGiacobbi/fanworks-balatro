local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_fnwk_bluebolt_sexy', key_2 = 'j_fnwk_gotequest_lambiekins'},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '?????',
        }
    }
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_added' then return false end

    local has_sexy = args.card.config.center.key == self.config.key_1
    local has_lambiekins = args.card.config.center.key == self.config.key_2
    for _, v in ipairs(G.jokers.cards) do
        if v.config.center.key == self.config.key_1 then
            has_sexy = true
        end

        if v.config.center.key == self.config.key_2 then
            has_lambiekins = true
        end

        if has_sexy and has_lambiekins then return true end
    end
end

return achInfo