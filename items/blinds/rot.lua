local blindInfo = {
    name = "The Rot",
    color = HEX('4F6367'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 4, max = 10},
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_consumeables = true
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_consumeables = nil
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_consumeables = nil
end

function blindInfo.fnwk_blind_load(self)
    G.GAME.modifiers.fnwk_no_consumeables = true
end

return blindInfo