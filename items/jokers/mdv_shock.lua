local jokerInfo = {
	name = 'Shock Humor',
	config = {
		extra = {
			hands_count = 7,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	fanwork = 'mdv',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.durandal }}
	return { vars = {card.ability.extra.hands_count} }
end


function jokerInfo.calculate(self, card, context)
	if not context.cardarea == G.jokers or card.debuff or context.blueprint then
        return
    end

	if context.joker_main then
		card.ability.extra.hands_count = card.ability.extra.hands_count - 1
		return {
			balance = true
		}
	end

	if context.after then
		if card.ability.extra.hands_count <= 0 then 
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.3,
						blockable = false,
						func = function()
								G.jokers:remove_card(self)
								card:remove()
								card = nil
							return true; end})) 
					return true
				end
			})) 
			return {
				message = localize('k_zap_ex'),
				colour = G.C.PURPLE
			}
		else
			return {
				message = localize{type='variable',key='a_remaining',vars={card.ability.extra.hands_count}},
				colour = G.C.PURPLE
			}
		end
	end
end

return jokerInfo