local consumInfo = {
    name = 'Moody Blues',
    set = "Stand",
    cost = 4,
    alerted = true,
    hasSoul = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return {}
end

function consumInfo.add_to_deck(self, card)
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime * 2
        end
    end
end

function consumInfo.remove_from_deck(self, card)
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime / 2
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo