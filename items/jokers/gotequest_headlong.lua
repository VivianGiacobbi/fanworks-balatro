local jokerInfo = {
	name = 'Headlong Flight',
	config = {
		extra = {
			hand_trigger = 1,
			discard_trigger = 0,
		}
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
	info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
	return { vars = {card.ability.extra.hand_trigger, card.ability.extra.discard_trigger}}
end

function jokerInfo.calculate(self, card, context)
	if context.pre_discard and not card.getting_sliced and not context.blueprint and (G.GAME.current_round.hands_left == card.ability.extra.hand_trigger and G.GAME.current_round.discards_left == card.ability.extra.discard_trigger) then
		G.GAME.dzrawlin = #G.deck.cards
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card:start_dissolve()
				return true
			end
		}))
	end

	if context.cardarea == G.jokers and context.before and not card.debuff and not context.blueprint and (G.GAME.current_round.hands_left == card.ability.extra.hand_trigger and G.GAME.current_round.discards_left == card.ability.extra.discard_trigger) then
		G.GAME.dzrawlin = #G.deck.cards
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card:start_dissolve()
				return true
			end
		}))
	end
end

return jokerInfo