local blindInfo = {
    name = "The Outlaw",
    color = HEX('a0a0cc'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 2, max = 10},
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_outlaw" })
end

function blindInfo.set_blind(self)
    self.played_ranks = {}
end

local function inPlayed(table, num)
    for i, v in ipairs(table) do
        if v == num then
            return true
        end
    end
    return false
end

local function checkDebuffs(self, card)
    if not self.disabled and card.area ~= G.jokers and #self.played_ranks > 0 then
        if not inPlayed(self.played_ranks, card:get_id()) then
            self:debuff_card(card)
        end
    end
end

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    if self.disabled then return end
    for k, v in pairs(cards) do
        if not inPlayed(self.played_ranks, v:get_id()) then
            self.played_ranks[#self.played_ranks + 1] = v:get_id()
        end
    end
    for _, v in ipairs(G.playing_cards) do
        checkDebuffs(self, v)
    end
end


return blindInfo