local jokerInfo = {
	key = 'j_fnwk_asap_jokestar',
	name = 'Adopted Jokestar',
	config = {
        extra = {
			h_size = 2,
			score_name = 'Flush'
		},
		added_h_size = 0,
    },
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'asap',
		},
		custom_color = 'asap',
	},
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.score_name, card.ability.extra.h_size }}
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end

	if context.end_of_round and context.main_eval and card.ability.added_h_size > 0 then
		G.hand:change_size(-card.ability.added_h_size)
		card.ability.added_h_size = 0
		return {
			card = card,
			message = localize('k_reset')
		}
	end

	if not card.debuff and context.joker_main and next(context.poker_hands[card.ability.extra.score_name]) then
		card.ability.added_h_size = card.ability.added_h_size + card.ability.extra.h_size
		G.hand:change_size(card.ability.extra.h_size)
		return {
			message = localize{type='variable',key='a_handsize',vars={card.ability.extra.h_size}},
			colour = G.C.FILTER,
			card = card,
		}
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if from_debuff then return end

	if card.ability.added_h_size > 0 then
		card.ability.added_h_size = 0
		G.hand:change_size(-card.ability.extra.h_size)
	end
end

return jokerInfo