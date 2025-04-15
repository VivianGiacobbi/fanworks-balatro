local consumInfo = {
    name = "The Damned",
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', '4F6367DC' },
        extra = {
            suits = {'Spades', 'Clubs'},
            scored_count = 0,
            num_scores = 6,
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
            card.ability.extra.num_scores - card.ability.extra.scored_count,
            localize(card.ability.extra.suits[1], 'suits_plural'),
            localize(card.ability.extra.suits[2], 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]]
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