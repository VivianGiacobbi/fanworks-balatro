local jokerInfo = {
	name = 'Fragile Joker',
	config = {},
	rarity = 3,
	cost = 9,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'mania',
		},
        custom_color = 'mania',
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.pre_playing_card_removed and SMODS.has_enhancement(context.removed, 'm_glass')
	and context.removed.glass_trigger then

		local sub_context = {
			cardarea = G.play,
			full_hand = G.play.cards,
			scoring_hand = context.scoring_hand,
			scoring_name = context.scoring_name,
			poker_hands = context.poker_hands,
			main_scoring = true,
		}
		context.removed.getting_sliced = nil
		local effects = { eval_card(context.removed, sub_context) }
		SMODS.calculate_quantum_enhancements(context.removed, effects, sub_context)
		sub_context.main_scoring = nil
		sub_context.individual = true
		sub_context.other_card = context.removed

		if next(effects) then
			SMODS.calculate_card_areas('jokers', sub_context, effects, { main_scoring = true })
			SMODS.calculate_card_areas('individual', sub_context, effects, { main_scoring = true })
		end

		SMODS.trigger_effects(effects, context.removed)

		sub_context.other_card = nil
		context.removed.getting_sliced = true
		context.removed.lucky_trigger = nil
		context.removed.fnwk_fragile_trigger = true
	end

	if context.post_playing_card_removed and context.removed.fnwk_fragile_trigger then
		return {
			func = function()
				local new_glass = SMODS.create_card({
					set = 'Enhanced',
					enhancement = 'm_glass',
					key = 'm_glass',
					skip_materialize = true,
				})

				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				new_glass.playing_card = G.playing_card
				table.insert(G.playing_cards, new_glass)
				G.deck.config.card_limit = G.deck.config.card_limit + 1

				new_glass.states.visible = false
				new_glass:add_to_deck()
				new_glass:hard_set_T(card.T.x, card.T.y + new_glass.T.h + 0.05, new_glass.T.w, new_glass.T.h)
				playing_card_joker_effects({new_glass})

				local juice_card = context.blueprint_card or card
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.6,
					func = function()
						new_glass.states.visible = true
						new_glass:start_materialize({G.C.SECONDARY_SET.Enhanced})
						juice_card:juice_up()
						return true
					end
				}))
				delay(0.9)
				draw_card(nil, G.discard, nil, 'up', false, new_glass)
			end
		}
	end
end

return jokerInfo