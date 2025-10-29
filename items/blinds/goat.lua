local blindInfo = {
    name = "The Goat",
    boss_colour = HEX('E078A0'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 6, max = 10},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
    artist = 'gote',
}

function blindInfo.debuff_hand(self, cards, hands, handname, check)
    if check or self.disabled then return end

    local ranks = {}
    for _, v in ipairs(cards) do
        ranks[v.base.value] = (ranks[v.base.value] or 0) + 1
    end

    for _, v in ipairs(cards) do
        if (ranks[v.base.value] or 0) > 1 then
            v.fnwk_goat_debuffed = true
            G.GAME.blind:debuff_card(v, true)
        end
    end
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.fnwk_goat_debuffed then
        card.fnwk_goat_debuffed = nil
        return true
    end

    return false
end

return blindInfo