local consumInfo = {
    name = 'KING & COUNTRY',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'DCFB8CDC', '5EEB2FDC' },
        extra = {
            money = 7
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'bone',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.money}}
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