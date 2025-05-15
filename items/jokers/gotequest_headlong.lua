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
	fanwork = 'gotequest'
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
	return { vars = {card.ability.extra.hand_trigger, card.ability.extra.discard_trigger}}
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint or not context.cardarea == G.jokers then return end

	if context.hand_drawn and card.ability.dzvalin_triggered then
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card:start_dissolve()
				return true
			end
		}))
	end

	if context.pre_draw and G.GAME.dzrawlin and not card.ability.dzvalin_triggered then
		card.ability.dzvalin_triggered = true
		G.GAME.dzrawlin = nil
	end

	if context.end_of_round and G.GAME.dzrawlin then
		card.ability.dzvalin_triggered = false
		G.GAME.dzrawlin = nil
	end

	if G.GAME.current_round.hands_left ~= card.ability.extra.hand_trigger or G.GAME.current_round.discards_left ~= card.ability.extra.discard_trigger or G.GAME.dzrawlin then
		return
	end
	if context.fnwk_change_discards or context.fnwk_change_hands and not G.GAME.dzrawlin then
		G.GAME.dzrawlin = true
		local eval = function() return G.GAME.dzrawlin == true end
        juice_card_until(card, eval, true)
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if G.GAME.dzrawlin and not next(SMODS.find_card('j_fnwk_gotequest_headlong')) then
		G.GAME.dzrawlin = nil
	end
end

return jokerInfo