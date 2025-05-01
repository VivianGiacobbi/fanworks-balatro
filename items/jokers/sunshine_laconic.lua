local jokerInfo = {
	key = 'j_fnwk_sunshine_laconic',
	name = 'Laconic Joker',
	config = {
		extra = {
			chips = 0,
            chips_mod = 8,
		},
	},
	rarity = 1,
	cost = 4,
	unlocked = false,
	unlock_condition = {type = 'consecutive_hands', num = 10},
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	fanwork = 'sunshine',

}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.fizzy }}
	return { vars = {card.ability.extra.chips_mod, card.ability.extra.chips} }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {self.unlock_condition.num} }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
	end

    return args.num_consecutive >= self.unlock_condition.num
end

function jokerInfo.calculate(self, card, context)
	if context.before and context.cardarea == G.jokers and not card.debuff and not context.blueprint then
        if #context.full_hand <= 3 then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod	
			return {
				message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
				card = card
			}
		elseif card.ability.extra.chips > 0 then
            card.ability.extra.chips = 0
            return {
                card = card,
                message = localize('k_reset')
            }
		end
	end
    
	if context.joker_main and context.cardarea == G.jokers and not card.debuff and card.ability.extra.chips > 0 then
		return {
			message = localize{ type='variable', key='a_chips', vars = {card.ability.extra.chips} },
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo