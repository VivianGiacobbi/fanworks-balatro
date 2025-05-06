local consumInfo = {
    name = "Electriclarryland",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', '4F6367DC' },
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'sunshine',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return consumInfo