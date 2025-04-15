local consumInfo = {
    name = 'Limelight',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        extra = {
            chance = 7
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'lighted',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, fnwk_enabled['enableQueer'] and 'Queer' or 'Polychrome'}}
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