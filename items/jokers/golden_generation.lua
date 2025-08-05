local jokerInfo = {
	name = 'Golden Generation',
	config = {
        extra = 1,
        initial_extra = 2
    },
	rarity = 2,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'golden',
		},
        custom_color = 'golden',
    },
    artist = 'reda'
}

local function fanworks_cards(card)
    if not G.jokers then
        return 0
    end

    local count = 0
    for i=1, #G.jokers.cards do
        local obj = G.jokers.cards[i].config.center
        if G.jokers.cards[i] ~= card and obj.original_mod and obj.original_mod.id == 'fanworks' then
            count = count + 1
        end
    end

    return count
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, (fanworks_cards(card) * card.ability.extra) + 2}}
end

function jokerInfo.calc_dollar_bonus(self, card)
    local bonus = (fanworks_cards(card) * card.ability.extra) + 2
    if bonus > 0 then
        return bonus
    end
end

return jokerInfo