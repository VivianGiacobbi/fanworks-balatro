local jokerInfo = {
	name = 'Will of One',
	config = {
		extra = {
			chips = 0,
			chip_mod = 1,
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'SegaciousCejai',
	programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.chips > 0 then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

	if context.pre_discard then
		local scale_table = {chip_mod = card.ability.extra.chip_mod * #context.full_hand}
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "chips",
			scalar_table = scale_table,
			scalar_value = "chip_mod",
			no_message = true,
		})

		if card.ability.extra.chips >= 300 then
			check_for_unlock({type = 'gotequest_city'})
		end

		return {
			message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
			colour = G.C.CHIPS,
			card = card,
			delay = 0.48,
		}
	end
end

return jokerInfo