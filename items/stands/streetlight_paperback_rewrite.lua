local consumInfo = {
    name = 'Paperback Writer: REWRITE',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        evolved = true,
        extra = {
            base_chance = 1000,
            chance = 1000
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
    return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance} }
end

return consumInfo