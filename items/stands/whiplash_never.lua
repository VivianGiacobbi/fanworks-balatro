local consumInfo = {
    name = 'Never Enough',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            consum_mod = 4
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'whiplash',
		},
        custom_color = 'whiplash',
    },
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.consum_mod} }
end

function consumInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    G.consumeables:change_size(card.ability.extra.consum_mod)
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

	G.consumeables:change_size(-card.ability.extra.consum_mod)
end

return consumInfo