local blindInfo = {
    name = "The Venus",
    color = HEX('E86EB5'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 3, max = 10},
}

function blindInfo.loc_vars(self)
    return {vars = {G.GAME.probabilities.normal, 2} }
end

function blindInfo.collection_loc_vars(self)
    return { vars = {G.GAME.probabilities.normal, 2}}
end

function blindInfo.set_blind(self)
    for _, v in ipairs(G.playing_cards) do
        v.fnwk_venus_debuff = (pseudorandom(pseudoseed('fnwk_venus')) < G.GAME.probabilities.normal/2) or nil
        v.fnwk_venus_checked = true
    end
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.area == G.jokers or G.GAME.blind.disabled then
        return false
    end

    if card.fnwk_venus_debuff then
        return true
    elseif not card.fnwk_venus_checked then
        card.fnwk_venus_checked = true
        card.fnwk_venus_debuff = (pseudorandom(pseudoseed('fnwk_venus')) < G.GAME.probabilities.normal/2) or nil
        
        if card.fnwk_venus_debuff then
            return true
        end
    end

    return false
end

function blindInfo.defeat(self)
    for _, v in ipairs(G.playing_cards) do
        v.fnwk_venus_debuff = nil
        v.fnwk_venus_checked = nil
    end
end

return blindInfo