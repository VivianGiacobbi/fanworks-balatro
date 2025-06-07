local consumInfo = {
    name = 'Mother Love Bone',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '4DEE74DC', '3AA330DC' },
        extra = {
            chance = 2
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'rubicon',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cream }}
    return {vars = {card.ability.extra.chance}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff or not context.before then return end

end

return consumInfo