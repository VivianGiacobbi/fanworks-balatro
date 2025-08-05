local jokerInfo = {
	name = 'Unknown Soldier',
	config = {
		extra = {
			hand_type = 'High Card',
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'noman',
		},
        custom_color = 'noman',
    },
	artist = 'coop'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {localize(card.ability.extra.hand_type, 'poker_hands')}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then
        return
    end

    if context.individual and context.cardarea == G.play and context.scoring_name == card.ability.extra.hand_type then
		if context.other_card.debuff then
			return {
				message = localize('k_debuffed'),
				colour = G.C.RED,
				card = context.blueprint_card or card,
			}
		else
			local mult = not SMODS.has_no_rank(context.other_card) and context.other_card.base.nominal
			return {
				mult = mult,
				card = context.blueprint_card or card,
			}
		end
	end
end

return jokerInfo