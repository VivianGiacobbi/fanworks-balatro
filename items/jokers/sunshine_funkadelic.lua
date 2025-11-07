local jokerInfo = {
	name = 'Funkadelic Joker',
	config = {
        extra = {
            x_mult = 2.5
        },
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
	artist = 'FizzyWizard',
	programmer = 'Vivian Giacobbi',
}

function jokerInfo.loc_vars(self, info_queue, card)
	local suits = {
		'Spades',
		'Hearts'
	}
	if G.GAME.fnwk_current_funky_suits then
		local i = 1
		for k, v in pairs(G.GAME.fnwk_current_funky_suits) do
			suits[i] = k
			i = i + 1
		end
	end

	return {
		vars = {
			card.ability.extra.x_mult,
			localize(suits[1], 'suits_singular'),
			localize(suits[2], 'suits_singular'),
			colours = {
				G.C.SUITS[suits[1]],
				G.C.SUITS[suits[2]]
			}
		}
	}
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and not card.debuff then
		local num_suits = 0
		local suit_map = {}
		for k, v in pairs(G.GAME.fnwk_current_funky_suits) do
			num_suits = num_suits + 1
			suit_map[k] = true
		end

		local suit_count = 0
		for _, v in ipairs(context.scoring_hand) do
			if not v.debuff and not SMODS.has_no_suit(v) then
				local has_any = SMODS.has_any_suit(v)
				if suit_map[v.base.suit] or has_any then
					suit_count = suit_count + 1
					if not has_any then
						suit_map[v.base.suit] = nil
					end
				end
			end
		end
		sendDebugMessage('suit count: '..suit_count)

		if suit_count >= num_suits then
			return {
				x_mult = card.ability.extra.x_mult,
				card = context.blueprint_card or card
			}
		end
	end
end

return jokerInfo