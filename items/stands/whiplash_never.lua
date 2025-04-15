local consumInfo = {
    name = 'Never Enough',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        
        extra = {
            consum_mod = 4
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'whiplash',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.consum_mod} }
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
    G.consumeables:change_size(card.ability.extra.consum_mod)
end

function consumInfo.remove_from_deck(self, card, from_debuff)
	G.consumeables:change_size(-card.ability.extra.consum_mod)
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo