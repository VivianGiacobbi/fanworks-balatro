local consumInfo = {
    name = 'Achtung Baby',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CDE3F0DC', 'EC9BEEDC' },
        evolve_key = 'j_fnwk_spirit_achtung_stranger',
        extra = {
            num_facedown = 1,
            x_mult = 2,
            evolve_hand = 'Five of a Kind'
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            FnwkFormatDisplayNumber(card.ability.extra.num_facedown, 'number', 'first'),
            card.ability.extra.x_mult,
            card.ability.extra.evolve_hand
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