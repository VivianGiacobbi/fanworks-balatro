local blindInfo = {
    name = "The Box",
    color = HEX('C2CDDF'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 2, max = 10},
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_hand_effects = true
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_hand_effects = nil
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_hand_effects = nil
end

function blindInfo.fnwk_blind_load(self)
    G.GAME.modifiers.fnwk_no_hand_effects = true
end

return blindInfo