local consumInfo = {
    name = "They're Red Hot",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FD5F55DC', 'FDA200DC' },
        extra = {
            suits = {'Hearts', 'Diamonds'},
            x_mult = 1,
            x_mult_mod = 0.1
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
    return { 
        vars = {
            card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult,
            localize(card.ability.extra.suits[1], 'suits_plural'),
            localize(card.ability.extra.suits[2], 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]],
            }
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