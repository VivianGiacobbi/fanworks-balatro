local consumInfo = {
    name = 'KING & COUNTRY',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CC2CDDFDC', '9C403ADC' },
        extra = {
            evolve_size = 0.825
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bone',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {math.floor(G.GAME.starting_deck_size * card.ability.extra.evolve_size)}}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo