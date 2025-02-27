local consumInfo = {
    key = 'c_fnwk_spec_stonemask',
    name = 'Stone Mask',
    set = "Spectral",
    cost = 4,
    alerted = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_holo
    info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
    return {}
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            local randomcard = pseudorandom_element(card.ellible_jokers, pseudoseed('stonemask'))
            randomcard:set_eternal(true)
            randomcard:set_edition({holo = true}, true)
            card:juice_up(0.3, 0.5)
            card.ellible_jokers = {}
            return true
        end)
    }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if not G.jokers then
        return
    end

    local elligible_jokers = {}
    for _, v in ipairs(G.jokers.cards) do
        if not v.edition and not v.ability.eternal and not v.ability.perishable then
            elligible_jokers[#elligible_jokers+1] = v
        end
    end

    card.ellible_jokers = elligible_jokers
    return #elligible_jokers > 0
end


return consumInfo