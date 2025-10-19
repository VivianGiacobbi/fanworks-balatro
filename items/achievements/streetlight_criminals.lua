local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_added' then return false end

    local has_teenage = args.card.config.center.key == 'j_fnwk_streetlight_teenage'
    local has_notorious = args.card.config.center.key == 'c_fnwk_streetlight_notorious'
    if not has_teenage then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_fnwk_streetlight_teenage' then
                has_teenage = true
                break
            end
        end
    end

    if not has_notorious then
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_fnwk_streetlight_notorious' then
                has_notorious = true
                break
            end
        end
    end

    return has_teenage and has_notorious
end

return achInfo