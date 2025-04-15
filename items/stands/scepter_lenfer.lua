local consumInfo = {
    name = "L'enfer",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        extra = {
            num_enhanced = 1,
            draw_size = 5,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'scepter',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {FnwkFormatDisplayNumber(card.ability.extra.num_enhanced), card.ability.extra.draw_size} }
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo