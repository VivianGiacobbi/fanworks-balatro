local consumInfo = {
    name = "Rockin' Robin",
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'F7ADADDC', 'FF6E65DC' },
        extra = {
            h_size_mod = 1,
            added_h_size = 0
        }
    },
    cost = 4,
    hasSoul = true,
    rarity = 'StandRarity',
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'piano',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.h_size_mod } }
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.retrigger_joker then return end

	if context.end_of_round and card.ability.extra.added_h_size > 0 then
		G.hand:change_size(-card.ability.extra.added_h_size)
		card.ability.extra.added_h_size = 0
		return {
			card = card,
			message = localize('k_reset')
		}
	end

	if not card.debuff and context.joker_main then
		card.ability.extra.added_h_size = card.ability.extra.added_h_size + card.ability.extra.h_size_mod
		G.hand:change_size(card.ability.extra.h_size_mod)
		return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize{type='variable',key='a_handsize',vars={card.ability.extra.h_size_mod}},
                colour = G.C.STAND,
            }
			
		}
	end
end

function consumInfo.remove_from_deck(self, card, from_debuff)
	if card.ability.extra.added_h_size > 0 then
		card.ability.extra.added_h_size = 0
		G.hand:change_size(-card.ability.extra.extra.h_size)
	end
end

return consumInfo