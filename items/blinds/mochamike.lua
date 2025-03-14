local blindInfo = {
    name = "Mocha Mike",
    color = HEX('a07c64'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 1, max = 10, showdown = true}
}

local function get_most_played()
    local most_played = "High Card"
    local play_more_than = (G.GAME.hands["High Card"].played or 0)
    for k, v in pairs(G.GAME.hands) do
        if v.played >= play_more_than and v.visible then
            play_more_than = v.played
            most_played = k
        end
    end
    return most_played
end

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_mochamike" })
end

function blindInfo.loc_vars(self)
    local most_played = get_most_played()
    return {vars = { localize(most_played, 'poker_hands') or localize('ph_most_played') } }
end

function blindInfo.collection_loc_vars(self)
    return {vars = { localize('ph_most_played') } }
end

function blindInfo.debuff_hand(self, cards, hand, handname, check)
    local most_played = get_most_played()
    if handname == most_played then
        return true
    end
end

return blindInfo