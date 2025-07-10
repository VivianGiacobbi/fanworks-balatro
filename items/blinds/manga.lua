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

function blindInfo.set_blind(self)
    G.GAME.modifiers.fnwk_no_rank_chips = true
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
        end
    end
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
        end
    end
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_no_rank_chips = nil
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
        end
    end
end

return blindInfo