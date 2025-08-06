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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'mania',
		},
        custom_color = 'mania',
    },
	artist = 'coop'
}

function jokerInfo.loc_vars(self, info_queue, card)
	local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fwnk_mania_cubist')
	return { vars = {num, dom, card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or context.blueprint then
		return
	end

	if context.before then
		local to_debuff = {}
		for k, v in ipairs(context.scoring_hand) do
			if not v.debuff and SMODS.has_enhancement(v, 'm_wild') then
				if SMODS.pseudorandom_probability(card, 'fnwk_mania_cubist', 1, card.ability.extra.chance, 'fwnk_mania_cubist') then 
					v.cubist_flagged = true
				else
					to_debuff[#to_debuff+1] = v
				end
			end
		end

		for _, v in ipairs(to_debuff) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					v:set_debuff(true)
					v:juice_up()
				return true
			end }))
		end

		if #to_debuff > 0 then
			return {
				message = localize('k_debuffed'),
				message_card = card
			}
		end
	end

	if context.individual and context.cardarea == G.play and context.other_card.cubist_flagged then
		context.other_card.cubist_flagged = nil
		return {
            chips = card.ability.extra.chips,
			mult = card.ability.extra.mult,
            card = card
        }
	end
end

return jokerInfo