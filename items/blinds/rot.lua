local blindInfo = {
    name = "The Rot",
    boss_colour = HEX('4F6367'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 4, max = 10},
    artist = 'BarrierTrio/Gote',
    programmer = 'Vivian Giacobbi',
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_consumeables = true
end

function blindInfo.press_play(self)
    for _, v in ipairs(G.consumeables) do
        if v.ability.consumeable then
            G.GAME.blind.triggered = true
            return
        end
    end

    G.GAME.blind.triggered = false
end

function blindInfo.recalc_debuff(self, card, from_blind)
    return card.ability.set == 'Stand' or card.ability.set == 'VHS'
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_consumeables = nil
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_consumeables = nil
end

function blindInfo.load(self, blindTable)
    G.GAME.modifiers.fnwk_no_consumeables = true
end

return blindInfo