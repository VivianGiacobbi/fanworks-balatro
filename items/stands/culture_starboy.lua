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
        if v.ability and v.ability.consumeable and v.ability.max_highlighted then 
            v.ability.max_highlighted = v.ability.max_highlighted + card.ability.extra.select_mod
        end
    end

    G.GAME.modifiers.consumable_selection_mod = (G.GAME.modifiers.consumable_selection_mod or 0) + card.ability.extra.select_mod
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    for _, v in pairs(G.I.CARD) do
        if v.ability and v.ability.consumeable and v.ability.max_highlighted then 
            v.ability.max_highlighted = v.ability.max_highlighted - card.ability.extra.select_mod
        end
    end

    if G.GAME.modifiers.consumable_selection_mod then
        G.GAME.modifiers.consumable_selection_mod = G.GAME.modifiers.consumable_selection_mod - card.ability.extra.select_mod
    end
end

return consumInfo