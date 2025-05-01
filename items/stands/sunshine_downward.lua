local consumInfo = {
    name = 'Downward Spiral',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'D36DD4DC', 'A3E7F6DC' },
        extra = {
            x_mult = 3
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'sunshine',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo