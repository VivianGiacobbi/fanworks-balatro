local consumInfo = {
    name = "Electriclarryland",
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'E58B6DDC', 'B72F7EDC' },
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'sunshine',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gar }}
end

return consumInfo