local consumInfo = {
    name = 'Starboy',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'culture',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

return consumInfo