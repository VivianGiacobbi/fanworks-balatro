local jokerInfo = {
	key = 'j_fnwk_industry_loyal',
	name = 'Loyal Gambler',
	config = {},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'industry',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	if not G.GAME or not G.GAME.current_loyal_suit then
		return { vars = {'Spades', colours = {G.C.SUITS['Spades']}} }
	end

	local suit = localize(G.GAME.current_loyal_suit, 'suits_singular')
	local color = G.C.SUITS[G.GAME.current_loyal_suit]
	return { vars = {suit, colours = {color}} }
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint or card.debuff then return end

    if context.check_enhancement and context.cardarea == G.jokers then
		if context.other_card.ability.effect ~= "Lucky Card" and context.other_card.ability.effect ~= "Stone Card" and
		(context.other_card.ability.effect == 'Wild Card' or context.other_card.base.suit == G.GAME.current_loyal_suit) then			
            return {
                ['m_lucky'] = true,
            }
        end
	end 
end

return jokerInfo