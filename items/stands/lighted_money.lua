local consumInfo = {
    name = 'Money Talks',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        extra = {
            dollars = 7
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'lighted',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.dollars}}
end

function consumInfo.calculate(self, card, context)

end

return consumInfo