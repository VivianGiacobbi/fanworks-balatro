local achInfo = {
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'city',
		},
        custom_color = 'city',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_card_added' or not next(SMODS.find_card('j_fnwk_city_neet')) then return false end

    local name = string.lower(args.card.config.center.name)
    return string.find(name, 'joker') or string.find(name, 'jokestar')
end

return achInfo