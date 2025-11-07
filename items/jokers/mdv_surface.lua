local jokerInfo = {
	name = 'Surface-Level Joker',
	config = {
		extra = {
			mult_mod = 4
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
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
	return { vars = {card.ability.extra.mult_mod} }
end


function jokerInfo.calculate(self, card, context)
	if card.debuff then
        return
    end

	if context.individual and context.cardarea == G.play and not context.other_card.debuff then
		local rank_array = {}
		for _, v in ipairs(context.scoring_hand) do
			rank_array[#rank_array+1] = v.base.nominal + (v.base.face_nominal or 0)
		end
		table.sort(rank_array, function(a, b) return a < b end)
		local highest = rank_array[#rank_array]
		local lowest = rank_array[1]

		local card_nom = context.other_card.base.nominal + (context.other_card.base.face_nominal or 0)
		if card_nom > lowest and card_nom < highest then
			return {
				mult = card.ability.extra.mult_mod
			}
		end
	end
end

return jokerInfo