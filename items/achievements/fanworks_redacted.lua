local achInfo = {
    rarity = 1,
    origin = 'fanworks',
}

 function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_added' then return false end

    local has_sexy = args.card.config.center.key == 'j_fnwk_bluebolt_sexy'
    local has_lambiekins = args.card.config.center.key == 'j_fnwk_gotequest_lambiekins'
    for _, v in ipairs(G.jokers.cards) do
        if v.config.center.key == 'j_fnwk_bluebolt_sexy' then
            has_sexy = true
        end

        if v.config.center.key == 'j_fnwk_gotequest_lambiekins' then
            has_lambiekins = true
        end

        if has_sexy and has_lambiekins then return true end
    end
end

return achInfo