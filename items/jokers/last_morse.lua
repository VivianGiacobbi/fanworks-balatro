local jokerInfo = {
	name = 'Morse Tapping',
	config = {
		extra = {
			ranks = 2,
			x_mult = 2,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'last',
		},
        custom_color = 'last',
    },
	artist = 'gote',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.x_mult, card.ability.extra.ranks}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main then
		-- TODO this'll need to be made quantum rank compatible
		local rank_map = {}
		local num_ranks = 0
		for _, v in ipairs(context.scoring_hand) do
			if not rank_map[v.base.value] then
				num_ranks = num_ranks + 1
				if num_ranks > card.ability.extra.ranks then
					return
				end

				rank_map[v.base.value] = true
			end
		end

		if num_ranks < card.ability.extra.ranks then
			return
		end

		return {
			x_mult = card.ability.extra.x_mult,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo