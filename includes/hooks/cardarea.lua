---------------------------
--------------------------- Hook for extra blinds
---------------------------

local ref_cardarea_highlighted = CardArea.parse_highlighted
function CardArea:parse_highlighted()
    for k, v in pairs(G.GAME.fnwk_extra_blinds) do
        v.fnwk_extra_boss_throw_hand = nil
    end

    return ref_cardarea_highlighted(self)
end