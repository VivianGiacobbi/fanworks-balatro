local consumInfo = {
    name = 'Ichor',
    set = 'Spectral',
    cost = 4,
    alerted = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
    artist = 'coop'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
    info_queue[#info_queue+1] = {key = 'rental', set = 'Other', vars = {G.GAME.rental_rate or 1}}
    return { vars = { fnwk_enabled['enable_Queer'] and 'Queer' or 'Polychrome' } }
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            local randomcard = pseudorandom_element(G.jokers.cards, pseudoseed('ichor'))
            randomcard:set_rental(true)
            randomcard:set_edition({polychrome = true}, true)
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