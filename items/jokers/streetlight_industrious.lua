local jokerInfo = {
	name = 'Industrious Streetlit Joker',
	config = {},
	rarity = 2,
	cost = 10,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'streetlight',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_leafy", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end
	if context.cardarea == G.jokers then
		if context.final_scoring_step and next(context.poker_hands['Full House']) then
			local rank = context.poker_hands["Three of a Kind"][1][1]:get_id()
			local rank_suffix = rank
			if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
			elseif rank_suffix == 10 then rank_suffix = 'T'
			elseif rank_suffix == 11 then rank_suffix = 'J'
			elseif rank_suffix == 12 then rank_suffix = 'Q'
			elseif rank_suffix == 13 then rank_suffix = 'K'
			elseif rank_suffix == 14 then rank_suffix = 'A'
			end
			local change_cards = {}
			for i=1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() ~= rank then
					change_cards[#change_cards+1] = context.scoring_hand[i]
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.15,
						func = function()
							context.scoring_hand[i]:flip()
							play_sound('card1')
							context.scoring_hand[i]:juice_up(0.3, 0.3)
							return true 
						end 
					}))
				end
			end
			for i=1, #change_cards do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						local suit_prefix = string.sub(context.scoring_hand[i].base.suit, 1, 1)..'_'
						change_cards[i]:set_base(G.P_CARDS[suit_prefix..rank_suffix])
						return true 
					end
				}))
			end
			for i=1, #change_cards do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function() 
						change_cards[i]:flip()
						play_sound('tarot2', 1, 0.6)
						change_cards[i]:juice_up(0.3, 0.3)
						return true 
					end 
				}))
			end
			delay(0.2)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_brienne')})
		end
	end
end

return jokerInfo