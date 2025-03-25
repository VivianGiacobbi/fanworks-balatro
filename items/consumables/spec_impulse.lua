local consumInfo = {
    key = 'c_fnwk_spec_ichor',
    name = 'Ichor',
    set = 'Spectral',
    cost = 4,
    alerted = true,
    fanwork = 'last'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_foil
    info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds, G.GAME.perishable_rounds}}
    info_queue[#info_queue+1] = {key = "artist_impulse", set = "Other"}
    return { vars = { fnwk_enabled['enableQueer'] and 'Queer' or 'Polychrome' } }
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            local randomcard = pseudorandom_element(G.jokers.cards, pseudoseed('impulse'))
            randomcard.ability.eternal = false
            randomcard:set_perishable(true)
            randomcard:set_edition({foil = true}, true)
            card:juice_up(0.3, 0.5)
            play_sound('gold_seal')
            return true
        end)
    }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if not G.jokers then
       return false
    end

    return #G.jokers.cards > 0
end


return consumInfo