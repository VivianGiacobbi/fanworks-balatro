local blindInfo = {
    name = "Auric Application",
    boss_colour = HEX('F3CF58'),
    pos = {x = 0, y = 0},
    dollars = 8,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10, showdown = true},
}

function blindInfo.press_play(self)
    G.GAME.blind.fnwk_application_hand = true
end

function blindInfo.drawn_to_hand(self)
    if not G.GAME.blind.fnwk_application_hand then return end

    for i=#G.jokers.cards, 1, -1 do
        local card = G.jokers.cards[i]
        if (card.ability.set == 'Joker' or card.ability.set == 'Stand') and not card.fnwk_work_submitted then
            card.fnwk_work_submitted = true
            G.GAME.blind:wiggle()
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_fnwk_submitted'),
                colour = self.boss_colour
            })
            G.GAME.blind:debuff_card(card, true)
            break
        end
    end
    G.GAME.blind.fnwk_application_hand = nil
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.area ~= G.jokers then
        return false
    end

    return card.fnwk_work_submitted
end

function blindInfo.disable(self)
    G.GAME.blind.fnwk_application_hand = nil
    for _, v in ipairs(G.jokers.cards) do
        v.fnwk_work_submitted = nil
    end
end

function blindInfo.defeat(self)
    G.GAME.blind.fnwk_application_hand = nil
    for _, v in ipairs(G.jokers.cards) do
        v.fnwk_work_submitted = nil
    end
end

return blindInfo