local jokerInfo = {
	key = 'j_fnwk_mania_jokestar',
	name = 'Cubist Jokestar',
	config = {
		extra = {
			chance = 2,
			chips = 13,
			mult = 12
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'mania',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if not context.cardarea == G.jokers or card.debuff or context.blueprint then
		return
	end

	if context.before then
		local debuffed = {}
		for k, v in ipairs(context.scoring_hand) do
			if not v.debuff then
				if pseudorandom(pseudoseed('cubist_roll')) > G.GAME.probabilities.normal / card.ability.extra.chance then 
					v.cubist_flagged = true
				else
					debuffed[#debuffed+1] = v
					v:set_debuff(true)
				end
			end
		end

		for i=1, #debuffed do
			G.E_MANAGER:add_event(Event({ 
				trigger = 'before',
				delay = 0.2,
				func = function() 
					debuffed[i]:juice_up()
				return true 
			end })) 
		end
		if #debuffed < #context.scoring_hand then 
			return {
				message = localize('k_debuffed'),
				message_card = card
			}
		end
	end

	if context.individual and context.cardarea == G.play and not context.other_card.debuff and context.other_card.cubist_flagged then
		context.other_card.cubist_flagged = nil
		return {
            chips = card.ability.extra.chips,
			mult = card.ability.extra.mult,
            card = card
        }
	end
end

return jokerInfo