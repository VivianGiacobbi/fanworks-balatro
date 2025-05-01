local consumInfo = {
    name = 'Thunderstruck D/C',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { '3EA8F3DC', '009CFDDC' },
        evolve_key = 'c_fnwk_bluebolt_thunder',
        evolved = true,
        extra = {
            hand = 'Flush'
        }
    },
    cost = 8,
    rarity = 'csau_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bluebolt',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.hand}}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo