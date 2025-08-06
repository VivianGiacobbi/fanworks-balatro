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

	if context.debuffed then return end

	if context.before and not card.debuff and #G.hand.cards > 0 then
        rand_card = pseudorandom_element(G.hand.cards, pseudoseed('standnameisplanetbbtw'))
        rand_card.steel_flag = true
    end

    if context.cardarea == G.jokers and context.final_scoring_step then
        if hand_chips*mult > G.GAME.blind.chips and rand_card and rand_card.steel_flag == true then
			G.E_MANAGER:add_event(Event({
				func = function()
					rand_card:set_ability(G.P_CENTERS.m_steel, nil, true)
					rand_card:juice_up()

					return true
				end
			})) 
			return {
				message = localize('k_steel'),
				card = context.blueprint_card or card
			}
		end
    end
    
end

return jokerInfo