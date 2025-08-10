local consumInfo = {
    name = 'Insane in the Brain',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'fnwk_rainbow', 'FFFFFFDC' },
        extra = {
            cost_mod = 2,
            card_mod = 2,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
    blueprint_compat = false,
}

function consumInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.set_center_discount(card, card.ability.extra.cost_mod, true, 'Booster')
        return true 
    end}))
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.clear_discount(card)
        return true 
    end}))
end

return consumInfo