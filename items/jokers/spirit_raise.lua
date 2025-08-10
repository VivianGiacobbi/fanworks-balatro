local jokerInfo = {
	name = 'The Raise',
	config = {extra = {blackjack = 21, hand_chips = 0}},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.blackjack, card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.play and context.individual and card.ability.extra.hand_chips <= 21 then
        local individual_chips = context.other_card.base.nominal + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
        card.ability.extra.hand_chips = card.ability.extra.hand_chips + individual_chips
        if card.ability.extra.hand_chips <= 21 then
            return {
                message = localize('k_hit'),
                card = card,
            }
        else
            return {
                message = localize('k_bust'),
                card = card,
            }
        end
    end
    if context.joker_main then
        if card.ability.extra.chips == 21 then
            card.ability.extra.chips = 0
            update_hand_text({nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
            return{
                message = localize('k_wp'),
                level_up = 1
            }
        else
            card.ability.extra.chips = 0
            return{
                message = localize('k_nd'),
            }
        end
    end
end

return jokerInfo
