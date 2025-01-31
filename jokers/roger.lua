local jokerInfo = {
	name = 'Mr. Roger',
	config = {
		extra = {
			x_mult = 1
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "rogernote", set = "Other"}
	info_queue[#info_queue+1] = {key = "guestartist13", set = "Other"}
	return { vars = {card.ability.extra.x_mult} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_roger" })
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.0,
				func = (function()
					card.ability.extra.x_mult = 1 + 0.5*(G.GAME.current_round.hands_played)
					return true
				end)}
			))
		end
		if card.ability.extra.x_mult > 1 then
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
				Xmult_mod = card.ability.extra.x_mult,
			}
		end
	end
	if context.end_of_round and not context.blueprint and card.ability.extra.x_mult > 1 then
		card.ability.extra.x_mult = 1
		return {
			message = localize('k_reset'),
			colour = G.C.RED
		}
	end
end



return jokerInfo
	