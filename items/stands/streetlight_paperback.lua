local consumInfo = {
    name = 'Paperback Writer',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        evolve_key = 'c_fnwk_streetlight_paperback_rewrite',
        extra = {
            spec_rerolls = 1,
            evolve_ante = 9
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'streetlight',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.spec_rerolls, card.ability.extra.evolve_ante} }
end

return consumInfo