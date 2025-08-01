local jokerInfo = {
    key = 'j_fnwk_careless_jokestar',
    name = 'Childish Jokestar',
    config = {
        extra = 0.5,
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'careless',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = { card.ability.extra * 100 } }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        FnwkSetCenterDiscount(card, card.ability.extra, true, 'Booster')
        return true 
    end}))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        FnwkClearCenterDiscountSource(card)
        return true 
    end}))
end

return jokerInfo