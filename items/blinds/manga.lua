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
}

local function set_fronts()
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
        end
    end
end

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_rank_chips = true
    set_fronts()
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    set_fronts()
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    set_fronts()
end

function blindInfo.fnwk_blind_load(self, blindTable)
    if G.GAME.modifiers.fnwk_no_rank_chips then
        set_fronts()
    end
end

return blindInfo