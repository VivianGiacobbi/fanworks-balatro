local jokerInfo = {
	name = 'Sanctuary City',
	config = {
		extra = {
			rank_id = 9,
			mult = 9,
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'iron',
		},
        custom_color = 'iron',
    },
	artist = 'CreamSodaCrossroads',
	programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.rank_id, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.individual and context.cardarea == G.play and ArrowAPI.stands.get_leftmost_stand()
	and context.other_card:get_id() == card.ability.extra.rank_id then
		return {
			mult = card.ability.extra.mult,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo