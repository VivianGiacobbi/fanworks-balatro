local consumInfo = {
    name = 'Fortunate Son',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF658BDC', 'FFE6AADC' },
        extra = {
            mult = 20,
            last_upgraded = nil
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'crimson',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.mult,
            card.ability.extra.last_upgraded or '',
            card.ability.extra.last_upgraded and '' or 'none'
        }
    }
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.calculate(self, card, context)

end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo