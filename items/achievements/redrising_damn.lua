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
        ['Queen'] = true,
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
    rarity = 1,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'redrising',
		},
        custom_color = 'redrising',
    },
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'modify_deck' or #G.playing_cards ~= 44 then return false end

    local deck_table = {}
    for k, v in pairs(G.playing_cards) do
        if SMODS.has_no_rank(v) or not references.ranks[v.base.value] or SMODS.has_no_suit(v) or not references.suits[v.base.suit] then
            return false
        end

        if deck_table[v.config.card_key] then return false end

        deck_table[v.config.card_key] = true
    end

    return true
end

return achInfo