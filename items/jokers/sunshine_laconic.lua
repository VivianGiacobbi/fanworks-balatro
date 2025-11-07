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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
	artist = 'FizzyWizard',
	programmer = 'Vivian Giacobbi',
}

function jokerInfo.loc_vars(self, info_queue, card)
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
	if card.debuff then return end

	if context.before and not context.blueprint then
        if #context.full_hand <= 3 then
			SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "chips", scalar_value = "chips_mod"})
		elseif card.ability.extra.chips > 0 then
            check_for_unlock({type = 'fnwk_laconic_reset', chips = card.ability.extra.chips})
			card.ability.extra.chips = 0
            return {
                card = card,
                message = localize('k_reset')
            }
		end
	end

	if context.joker_main and card.ability.extra.chips > 0 then
		return {
			chips = card.ability.extra.chips,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo