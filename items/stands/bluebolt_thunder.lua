local consumInfo = {
    name = 'Thunderstruck A/C',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { '3EA8F3DC', '009CFDDC' },
        evolve_key = 'c_fnwk_bluebolt_thunder_dc',
        extra = {
            avoid_hand = 'Flush',
            x_mult = 2,
            evolve_procs = 0,
            evolve_num = 15
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bluebolt',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.avoid_hand,
            card.ability.extra.x_mult,
            card.ability.extra.evolve_procs - card.ability.extra.evolve_num
        }
    }
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.calculate(self, card, context)

end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo