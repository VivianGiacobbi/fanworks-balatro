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
	fanwork = 'golden',
}

local function fanworks_cards(card)
    if not G.jokers then
        return 0
    end

    local count = 0
    for i=1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and StringStartsWith(G.jokers.cards[i].config.center.key, 'j_fnwk_') then
            count = count + 1
        end
    end

    return count
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_reda", set = "Other"} 
    return { vars = {card.ability.extra, (fanworks_cards(card) * card.ability.extra) + 2}}
end

function jokerInfo.calc_dollar_bonus(self, card)
    local bonus = (fanworks_cards(card) * card.ability.extra) + 2
    if bonus > 0 then
        return bonus
    end
end

return jokerInfo