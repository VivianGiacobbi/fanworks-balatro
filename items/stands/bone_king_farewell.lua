local consumInfo = {
    name = 'Farewell to Kings',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CBD4E7DC', 'FD5F55DC' },
        extra = {
            blind_mod = 0.5
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bone',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.blind_mod * 100}}
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