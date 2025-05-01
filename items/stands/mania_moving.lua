local consumInfo = {
    name = 'Moving Pictures',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FDD48EDC', 'EEBA64DC' },
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'mania',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo