local consumInfo = {
    name = 'Mother Love Bone',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF5B6DDC', 'C4005DDC' },
        extra = {
            rank = 12,
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

    local steels = 0
    for _, v in ipairs(context.scoring_hand) do
        if v:get_id() == card.ability.extra.rank 
        and pseudorandom(pseudoseed('fnwk_rubicon_mother')) < G.GAME.probabilities.normal/card.ability.extra.chance then 
            steels = steels + 1
            v:set_ability(G.P_CENTERS.m_steel, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up()
                    return true
                end
            })) 
        end
    end
    if steels > 0 then 
        return {
            message = localize('k_steel'),
            colour = G.C.STAND,
        }
    end
end

return consumInfo