local consumInfo = {
    name = 'Starboy',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            select_mod = 1,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'culture',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = { card.ability.extra.select_mod}}
end

function consumInfo.add_to_deck(self, card, from_debuff)
    for _, v in pairs(G.I.CARD) do
        if v.ability and v.ability.max_highlighted then 
            v.ability.max_highlighted = v.ability.max_highlighted + card.ability.extra.select_mod
        end
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or context.retrigger_joker then return end

    if context.fnwk_created_card then
        if not (context.card.ability and context.card.ability.max_highlighted) then
            return
        end 

        context.card.ability.max_highlighted = context.card.ability.max_highlighted + card.ability.extra.select_mod
    end
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    for _, v in pairs(G.I.CARD) do
        if v.ability and v.ability.max_highlighted then 
            v.ability.max_highlighted = v.ability.max_highlighted - card.ability.extra.select_mod
        end
    end
end

return consumInfo