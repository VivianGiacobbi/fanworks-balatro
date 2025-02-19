local jokerInfo = {
	name = 'Secluded Rust Joker',
	config = {
		extra = 1,
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_winter", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.pre_draw then
		if context.drawn:is_suit('Diamonds') then
			context.drawn.joker_force_facedown = true
		end
	end

	if not context.repetition or not context.cardarea == G.play or card.debuff then
		return
	end

	local retriggers = 0
	if context.other_card:is_suit('Diamonds') then
		retriggers = card.ability.extra
	end

	if context.other_card:get_id() == 11 then
		retriggers = retriggers + 1
	end
	
	if retriggers > 0 then
		return {
			message = localize('k_again_ex'),
			repetitions = retriggers,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo