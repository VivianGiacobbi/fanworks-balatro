local consumInfo = {
    name = 'My Chemical Romance',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FD5F55DC', 'DD463CDC' },
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
    fanwork = 'bluebolt',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    local num_display = (card.ability.extra.stored_enhance and 1 or 0) + (card.ability.extra.stored_seal and 1 or 0) + (card.ability.extra.stored_edition and 1 or 0)
    return { vars = {
            card.ability.extra.stored_enhance or (num_display == 0 and 'those') or '',
            card.ability.extra.stored_enhance and (num_display > 2 and ', ' or ' and ') or '',
            card.ability.extra.stored_seal or (num_display == 0 and ' modifiers') or '',
            card.ability.extra.stored_seal and (((num_display > 2 and not card.ability.extra.stored_enhance) and ' and ') or ((num_display > 2) and ', '))  or '',
            card.ability.extra.stored_edition or '',
        }
    }
end

function consumInfo.calculate(self, card, context)

end

return consumInfo