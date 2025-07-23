local blindInfo = {
    name = "The Written",
    boss_colour = HEX('CECEC4'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10},
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_suits = true
    FnwkSetFronts()
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_suits = nil
    FnwkSetFronts(true)
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_suits = nil
    FnwkSetFronts()
end

function blindInfo.fnwk_blind_load(self, blindTable)
    if G.GAME.modifiers.fnwk_no_suits then
        FnwkSetFronts()
    end
end

return blindInfo