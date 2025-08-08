local jokerInfo = {
	key = 'j_fnwk_gotequest_2hot',
	name = '2HOT2HANDLE',
	config = { rand_card },
	rarity = 2,
	cost = 7,
	locked = true,
	unlocked = false,
	unlock_condition = {type = 'chip_nova', count = 18},
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {ArrowAPI.string.count_grammar(self.unlock_condition.count)}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then return end

	return args.total_novas >= self.unlock_condition.count
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

    if context.after and hand_chips*mult > G.GAME.blind.chips then
		local valid_targets = {}
		for _, v in pairs(G.hand.cards) do
			if v.config.center.key ~= 'm_steel' then
				valid_targets[#valid_targets+1] = v
			end
		end

		local rand_card = pseudorandom_element(valid_targets, 'fnwk_gotequest_2hot')
		rand_card:set_ability(G.P_CENTERS.m_steel, nil, 'manual')

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.15,
			func = function()
				rand_card:flip()
				play_sound('card1')
				rand_card:juice_up(0.3, 0.3)
				return true 
			end 
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				rand_card:set_sprites(rand_card.config.center)
				rand_card.front_hidden = rand_card:should_hide_front()
				return true 
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.35,
			func = function()
				rand_card:flip()
				play_sound('tarot2', 1, 0.6)
				rand_card:juice_up(0.3, 0.3)
				return true
			end
		}))

		return {
			delay = 0.75,
			message = localize('k_steel'),
			card = context.blueprint_card or card
		}
    end
end

return jokerInfo