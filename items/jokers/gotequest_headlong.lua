local jokerInfo = {
	key = 'j_fnwk_gotequest_headlong',
	name = 'Headlong Flight',
	config = {
		extra = {
			hand_trigger = 1,
			discard_trigger = 0,
		},
		effect_triggered = nil,
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = false,
	perishable = true,
    hasSoul = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'BarrierTrio/Gote',
	programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.hand_trigger, card.ability.extra.discard_trigger}}
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end

	if context.hand_drawn and card.ability.dzvalin_triggered then
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card:start_dissolve()
				return true
			end
		}))
	end

	if card.ability.dzvalin_ready and context.drawing_cards and context.amount < #G.deck.cards then
		card.ability.dzvalin_triggered = true
		card.ability.dzvalin_ready = nil
		return {
			cards_to_draw = #G.deck.cards
		}
	end

	if context.end_of_round and context.main_eval and card.ability.dzvalin_ready then
		card.ability.dzvalin_triggered = nil
		card.ability.dzvalin_ready = nil
	end

	if G.GAME.current_round.hands_left ~= card.ability.extra.hand_trigger or G.GAME.current_round.discards_left ~= card.ability.extra.discard_trigger or G.GAME.dzrawlin then
		return
	end

	if context.fnwk_change_discards or context.fnwk_change_hands and not card.ability.dzvalin_ready then
		card.ability.dzvalin_ready = true
		local eval = function() return card.ability.dzvalin_ready == true end
        juice_card_until(card, eval, true)
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if card.ability.dzvalin_ready and not next(SMODS.find_card('j_fnwk_gotequest_headlong')) then
		card.ability.dzvalin_ready = nil
	end
end

return jokerInfo