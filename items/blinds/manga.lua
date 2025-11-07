local blindInfo = {
    name = "The Manga",
    boss_colour = SMODS.Gradients['fnwk_blind_rainbow_light'],
    special_colour = SMODS.Gradients['fnwk_blind_rainbow_dark'],
    tertiary_colour = SMODS.Gradients['fnwk_blind_rainbow_dim'],
    contrast = 1,
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 2, max = 10},
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi',
}

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_rank_chips = true
    ArrowAPI.misc.set_fronts()
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    ArrowAPI.misc.set_fronts(true)
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    ArrowAPI.misc.set_fronts()
end

function blindInfo.load(self, blindTable)
    if G.GAME.modifiers.fnwk_no_rank_chips then
        ArrowAPI.misc.set_fronts()
    end
end

return blindInfo