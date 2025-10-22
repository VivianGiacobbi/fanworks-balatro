local consumInfo = {
    name = 'Starboy',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '9F6BF1DC', '5D48CADC' },
        extra = {
            select_mod = 1,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'culture',
		},
        custom_color = 'culture',
    },
    blueprint_compat = false,
    artist = {
        'cream',
        'winter',
    }
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.select_mod}}
end

function consumInfo.add_to_deck(self, card, from_debuff)
    ArrowAPI.game.consumable_selection_mod(card.ability.extra.select_mod)
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    ArrowAPI.game.consumable_selection_mod(-card.ability.extra.select_mod)
end

return consumInfo