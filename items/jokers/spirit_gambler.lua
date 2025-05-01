local jokerInfo = {
	name = 'The Gambler',
	config = {extra = {blackjack = 21, chips = 0}},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'spirit',
    in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.daed }}
    return { vars = { card.ability.extra.blackjack, card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.play and context.individual and card.ability.extra.chips <= 21 then
        local individual_chips = context.other_card.base.nominal + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
        card.ability.extra.chips = card.ability.extra.chips + individual_chips
        if card.ability.extra.chips <= 21 then
            return {
                message = localize('f_hit'),
                card = card,
            }
        else
            return {
                message = localize('f_bust'),
                card = card,
            }
        end
    end
    if context.cardarea == G.jokers and context.joker_main then
        if card.ability.extra.chips <= 21 then
            card.ability.extra.chips = 0
            update_hand_text({nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
            return{
                message = localize('f_wp'),
                level_up = 1
            }
        else
            card.ability.extra.chips = 0
            return{
                message = localize('f_nd'),
            }
        end
    end
end

return jokerInfo
