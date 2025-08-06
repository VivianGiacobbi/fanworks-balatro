local jokerInfo = {
	name = 'Unsure Joker',
	config = {
	},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'plancks',
		},
        custom_color = 'plancks',
    },
	artist = 'coop',
	alt_art = true
}

function jokerInfo.calculate(self, card, context)
	if context.repetition and context.cardarea == G.play and not card.debuff and not context.other_card.debuff then
		if not context.other_card:is_face() and context.other_card.ability.effect ~= "Base" then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		end
	end
end

return jokerInfo