local jokerInfo = {
	name = 'One True Pair',
	config = {
		extra = {
			chance = 15
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'gote',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_gotequest_pair')} }
end

function jokerInfo.calculate(self, card, context)
    if not context.before or context.scoring_name ~= 'Pair' or card.debuff then
		return
	end

	local valid = false
	for i, v in ipairs(context.scoring_hand) do
		if not v.debuff then
			valid = true
			break
		end
	end

	if not valid then
        return
    end

	if SMODS.pseudorandom_probability(card, 'fnwk_gotequest_pair', 1, card.ability.extra.chance, 'fnwk_gotequest_pair') then
		for i, v in ipairs(context.scoring_hand) do
			if not v.debuff then
				v:set_edition({polychrome = true}, nil, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				}))
			end
		end

		return {
			message = localize('k_nowkiss'),
			card = context.blueprint_card or card,
		}
	end

	
end

return jokerInfo