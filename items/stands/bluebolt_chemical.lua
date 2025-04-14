local consumInfo = {
    name = 'My Chemical Romance',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'DCFB8CDC', '5EEB2FDC' },
        extra = {
            stored_enhance = nil,
            stored_seal = nil,
            stored_edition = nil
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'bluebolt',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    local num_display = (card.ability.extra.stored_enhance and 1 or 0) + (card.ability.extra.stored_seal and 1 or 0) + (card.ability.extra.stored_edition and 1 or 0)
    return { vars = {
            card.ability.extra.stored_enhance or '',
            card.ability.extra.stored_enhance and (num_display > 2 and ', ' or ' and ') or '',
            card.ability.extra.stored_seal or '',
            card.ability.extra.stored_seal and (((num_display > 2 and not card.ability.extra.stored_enhance) and ' and ') or ((num_display > 2) and ', '))  or '',
            card.ability.extra.stored_edition or '',
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