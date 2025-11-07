local blindInfo = {
    name = "The Work",
    boss_colour = HEX('DD85B4'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {1},
    boss = {min = 3, max = 10},
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi',
}

function blindInfo.loc_vars(self)
    return {vars = {1} }
end

function blindInfo.collection_loc_vars(self)
    return { vars = {1}}
end

function blindInfo.set_blind(self)
    G.GAME.blind.fnwk_required_works = 1
    G.GAME.blind.fnwk_works_submitted = 0
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.area ~= G.jokers and card.area ~= G.consumeables then
        return false
    end

    return card.fnwk_work_submitted
end

function blindInfo.disable(self)
    G.GAME.blind.fnwk_required_works = 0
    for _, v in ipairs(G.jokers.cards) do
        v.fnwk_work_submitted = nil
    end
    for _, v in ipairs(G.consumeables.cards) do
        v.fnwk_work_submitted = nil
    end
end

function blindInfo.defeat(self)
    for _, v in ipairs(G.jokers.cards) do
        v.fnwk_work_submitted = nil
    end
    for _, v in ipairs(G.consumeables.cards) do
        v.fnwk_work_submitted = nil
    end
end

function blindInfo.save(self, saveTable)
    saveTable.fnwk_works_submitted = G.GAME.blind.fnwk_works_submitted
	saveTable.fnwk_required_works = G.GAME.blind.fnwk_required_works
    return saveTable
end

function blindInfo.load(self, blindTable)
    G.GAME.blind.fnwk_works_submitted = blindTable.fnwk_works_submitted
	G.GAME.blind.fnwk_required_works = blindTable.fnwk_required_works
end

return blindInfo