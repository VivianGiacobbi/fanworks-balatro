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
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance} }
end

function jokerInfo.calculate(self, card, context)
    if not (context.before and context.cardarea == G.jokers) then
		return
	end
    if card.debuff then
        return
    end

    if context.scoring_name ~= 'Pair' then
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

    local seed_result = pseudorandom(pseudoseed('gaypeople'))
	if seed_result < G.GAME.probabilities.normal / card.ability.extra.chance then
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