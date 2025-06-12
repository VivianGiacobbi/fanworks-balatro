local consumInfo = {
    name = 'Insane in the Brain',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'fnwk_rainbow', 'FFFFFFDC' },
        extra = {
            cost_mod = 2,
            card_mod = 2,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'bluebolt',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function consumInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        FnwkSetCenterDiscount(card, card.ability.extra.cost_mod, true, 'Booster')
        return true 
    end}))
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        FnwkClearCenterDiscountSource(card)
        return true 
    end}))
end

return consumInfo