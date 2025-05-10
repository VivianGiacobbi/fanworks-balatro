local consumInfo = {
    name = 'Dead Weight',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'DCFB8CDC', '4CB3D9DC' },
        extra = {
            tarot = 'c_hermit'
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'city',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.P_CENTERS[card.ability.extra.tarot].name}}
end

return consumInfo