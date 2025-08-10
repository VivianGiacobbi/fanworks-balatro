local jokerInfo = {
	name = 'Methodical Joker',
	config = {
		extra = {
			hands_val = 4,
			current_hands = 0,
			hands_mod = 1,
		},
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
	artist = 'leafy',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.hands_val, card.ability.extra.current_hands } }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.before then
		if not context.blueprint and not context.retrigger_joker then
			card.ability.extra.current_hands = card.ability.extra.current_hands + card.ability.extra.hands_mod
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "current_hands",
				scalar_table = scale_table,
				scalar_value = "hands_mod",
			})
		end
		
		if card.ability.extra.current_hands >= card.ability.extra.hands_val then
			if not context.blueprint and not context.retrigger_joker then
				local scale_table = { hands_mod = card.ability.extra.current_hands }
				card.ability.extra.current_hands = card.ability.extra.current_hands - scale_table.hands_mod
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "current_hands",
					scalar_table = scale_table,
					scalar_value = "hands_mod",
				})
			end
			return {
				card = context.blueprint_card or card,
				level_up = true,
				message = localize('k_method_4')
			}
		elseif not context.blueprint and not context.retrigger_joker then
			return {
				message = localize('k_method_'..card.ability.extra.current_hands+1)
			}
		end
	end

	if context.blueprint or not context.retrigger_joker then return end

	if context.pre_discard and card.ability.extra.current_hands > 0 then
		local scale_table = { hands_mod = card.ability.extra.current_hands }
		card.ability.extra.current_hands = card.ability.extra.current_hands - scale_table.hands_mod
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "current_hands",
			scalar_table = scale_table,
			scalar_value = "hands_mod",
		})
		return {
			card = card,
			message = localize('k_reset')
		}
	end

	if context.after then
		
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "current_hands",
			scalar_value = "hands_mod",
		})
		if card.ability.extra.current_hands >= card.ability.extra.hands_val then
			card.ability.extra.current_hands = 0
		end
	end
end

return jokerInfo