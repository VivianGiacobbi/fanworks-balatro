local jokerInfo = {
	name = 'Sanctuary City',
	config = {
		extra = {
			rank_id = 9,
			mult = 9,
			tempmult = 0
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'iron',
	dependencies = {'ArrowAPI'},
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = { card.ability.extra.rank_id, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if G.FUNCS.get_leftmost_stand() then
		if (context.before and context.cardarea == G.jokers) then
			card.ability.extra.tempmult = 0
			for k, v in ipairs(scoring_hand) do
				if (v:get_id() == rank_id) and not v.debuff then
					card.ability.extra.tempmult = card.ability.extra.tempmult + card.ability.extra.mult
				end
			end
		end

		if context.cardarea == G.jokers and context.joker_main and not card.debuff and card.ability.extra.tempmult > 0 then
			return {
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.tempmult or 0}},
				mult_mod = card.ability.extra.tempmult,
				card = context.blueprint_card or card
			}
		end
	end
end

return jokerInfo