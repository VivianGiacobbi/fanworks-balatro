local consumInfo = {
    name = 'Big Poppa',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'DCFB8CDC', '5EEB2FDC' },
        extra = {
            x_mult = 2,
            chance = 2,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'glass',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = { card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.chance }}
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