local jokerInfo = {
    name = 'Joepiejee',
	config = {
        extra = {
            h_mod = 1,
        },
        last_size = 1,
    },
	rarity = 4,
	cost = 20,
    unlocked = false,
    hasSoul = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jspec'
}

local function get_lowest_planet()
    local hands = {
        'Straight Flush',
        'Four of a Kind',
        'Full House',
        'Flush',
        'Straight',
        'Three of a Kind',
        'Two Pair',
        'Pair',
        'High Card',
    }

    local lowest = 0
    for i=1, #hands do
        if i == 1 then lowest = G.GAME.hands[hands[i]].level end
        if G.GAME.hands[hands[i]].level < lowest then lowest = G.GAME.hands[hands[i]].level end
    end
    return lowest
end


function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
    return { vars = { card.ability.extra.h_mod, get_lowest_planet() * card.ability.extra.h_mod }}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.hand:change_size(get_lowest_planet() * card.ability.extra.h_mod)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.hand:change_size(-get_lowest_planet() * card.ability.extra.h_mod)
end

function jokerInfo.calculate(self, card, context)
    if not (context.cardarea == G.jokers and context.hand_upgraded) or context.blueprint then
        return
    end

    local hand_size = get_lowest_planet() * card.ability.extra.h_mod
    if hand_size == card.ability.last_size then
        return
    end

    G.hand:change_size(hand_size - card.ability.last_size)
    sendDebugMessage('current: '..hand_size..' | last: '.. card.ability.last_size)
    if hand_size > card.ability.last_size then
        card.ability.last_size = hand_size
        return {
            message = localize('k_upgrade_ex'),
            card = card,
        }
    end
    card.ability.last_size = hand_size
end

return jokerInfo