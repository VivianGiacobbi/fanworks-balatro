local consumInfo = {
    name = "Electriclarryland",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
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

function consumInfo.calculate(self, card, context)

end

return consumInfo