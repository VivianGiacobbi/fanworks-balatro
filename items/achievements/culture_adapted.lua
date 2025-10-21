local references = {
    ranks = {
        ['2'] = true,
        ['3'] = true,
        ['4'] = true,
        ['5'] = true,
        ['6'] = true,
        ['7'] = true,
        ['8'] = true,
        ['9'] = true,
        ['10'] = true,
        ['Jack'] = true,
        ['Queen'] = true,
        ['King'] = true,
        ['Ace'] = true
    },
    suits = {
        ['Hearts'] = true,
        ['Spades'] = true,
        ['Diamonds'] = true,
        ['Clubs'] = true,
    }
}

local achInfo = {
    rarity = 2,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'culture',
		},
        custom_color = 'culture',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'modify_deck' or #G.playing_cards ~= 52 then return false end

    local deck_table = {}
    for k, v in pairs(G.playing_cards) do
        if SMODS.has_no_rank(v) or not references.ranks[v.base.value]
        or SMODS.has_no_suit(v) or not references.suits[v.base.suit]
        or v.config.center.key == 'c_base' then
            return false
        end

        if deck_table[v.config.card_key] then return false end

        deck_table[v.config.card_key] = true
    end

    return true
end

return achInfo