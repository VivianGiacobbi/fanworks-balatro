local jokerInfo = {
	name = 'Shock Humor',
	config = {
		extra = {
			hands_count = 7,
			hands_mod = 1,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'mdv',
		},
        custom_color = 'mdv',
    },
	artist = 'Durandal',
	programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.hands_count} }
end


function jokerInfo.calculate(self, card, context)
	if card.debuff or context.blueprint then
        return
    end

	if context.joker_main then
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "hands_count",
			scalar_value = "hands_mod",
			operation = "-",
			no_message = true,
		})
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
							return true
						end
					}))
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