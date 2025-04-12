local jokerInfo = {
	key = 'j_fnwk_cis_jokestar',
    name = 'Ice-Cold Jokestar',
    config = {
        extra = {
            mult = 30,
            remaining = 3
        }
    },
    rarity = 1,
    cost = 5,
	unlocked = false,
	unlock_condition = {type = 'win_custom', max_novas = 2},
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    fanwork = 'cis',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { 
		vars = { 
			card.ability.extra.mult,
			card.ability.extra.remaining,
			card.ability.extra.remaining > 1 and 's' or ''
		}
	}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {FnwkCountGrammar(self.unlock_condition.max_novas)}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then return end

	return G.GAME.chip_novas <= self.unlock_condition.max_novas
end

function jokerInfo.calculate(self, card, context)
    if not context.cardarea == G.jokers then
		return
	end

    if context.joker_main then
        return {
            mult = card.ability.extra.mult,
            colour = G.C.RED,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then
        return
    end

    if context.after and G.GAME.blind.chips <= hand_chips*mult then
        card.ability.extra.remaining = card.ability.extra.remaining - 1
		if card.ability.extra.remaining <= 0 then 
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
				message = localize('k_melted_ex'),
				colour = G.C.FILTER
			}
		else
			return {
				message = localize{type='variable',key='a_remaining',vars={card.ability.extra.remaining}},
				colour = G.C.BLUE
			}
		end
	end
end

return jokerInfo