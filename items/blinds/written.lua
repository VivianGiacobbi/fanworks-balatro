local blindInfo = {
    name = "The Written",
    boss_colour = HEX('CECEC4'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10},
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi',
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_suits = true
    ArrowAPI.misc.set_fronts()
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_suits = nil
    ArrowAPI.misc.set_fronts(true)
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_suits = nil
    ArrowAPI.misc.set_fronts()
end

function blindInfo.load(self, blindTable)
    if G.GAME.modifiers.fnwk_no_suits then
        ArrowAPI.misc.set_fronts()
    end
end

function blindInfo.in_pool(self)
    if (not G.ACHIEVEMENTS['ach_fnwk_rockhard_gremmie'] or G.ACHIEVEMENTS['ach_fnwk_rockhard_gremmie'].earned) and G.P_CENTERS['j_shoot_the_moon'].unlocked then
        return true
    end
end

return blindInfo