local jokerInfo = {
    key = 'j_fnwk_careless_jokestar',
    name = 'Childish Jokestar',
    config = {
        extra = 0.5,
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'careless',
		},
        custom_color = 'careless',
    },
    artist = 'coop',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra * 100 } }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.set_center_discount(card, card.ability.extra, true, 'Booster')
        return true 
    end}))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        ArrowAPI.game.clear_discount(card)
        return true 
    end}))
end

return jokerInfo