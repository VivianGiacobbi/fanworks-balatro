local consumInfo = {
    name = 'Miracle Row',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolve_key = 'c_fnwk_jspec_miracle_together',
        aura_colors = { 'FFD4BFDC', 'FFAF71DC' },
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'jspec',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)

end

return consumInfo