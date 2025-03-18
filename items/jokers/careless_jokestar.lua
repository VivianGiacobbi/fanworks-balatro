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
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
    return { vars = { card.ability.extra * 100 } }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    local old_discount = G.GAME.discount_percent
    G.GAME.discount_percent = G.GAME.discount_percent + (100 - G.GAME.discount_percent) * card.ability.extra
    
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        for k, v in pairs(G.I.CARD) do
            if v.ability and v.ability.set == 'Booster' and v.set_cost then 
                v:set_cost()
            end
        end
        G.GAME.discount_percent = old_discount
        return true 
    end}))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        for k, v in pairs(G.I.CARD) do
            if v.ability and v.ability.set == 'Booster' and v.set_cost then 
                v:set_cost()
            end
        end
        return true 
    end}))
end

return jokerInfo