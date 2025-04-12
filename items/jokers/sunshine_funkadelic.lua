local jokerInfo = {
	name = 'Funkadelic Joker',
	config = {
        extra = {
            x_mult = 2.5
        },
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'sunshine',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_fizzy", set = "Other"}
	if G.GAME and not G.GAME.fnwk_current_funky_suits then
		fnwk_reset_funkadelic()
	end

	local firstSuit = localize(G.GAME.fnwk_current_funky_suits[1], 'suits_singular')
	local firstColor = G.C.SUITS[G.GAME.fnwk_current_funky_suits[1]]
	local secondSuit = localize(G.GAME.fnwk_current_funky_suits[2], 'suits_singular')
	local secondColor = G.C.SUITS[G.GAME.fnwk_current_funky_suits[2]]
	return { vars = {card.ability.extra.x_mult, firstSuit, secondSuit, colours = {firstColor, secondColor}} }
end

function jokerInfo.calculate(self, card, context)  
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		local suits = {
			['Hearts'] = 0,
			['Diamonds'] = 0,
			['Spades'] = 0,
			['Clubs'] = 0
		}
		
		for i = 1, #context.scoring_hand do
			if not context.scoring_hand[i].debuff then
				if context.scoring_hand[i]:is_suit('Hearts') or context.scoring_hand[i].ability.effect == 'Wild Card' then 
					suits['Hearts'] = suits['Hearts'] + 1
				elseif context.scoring_hand[i]:is_suit('Diamonds') or context.scoring_hand[i].ability.effect == 'Wild Card'  then
					suits['Diamonds'] = suits['Diamonds'] + 1
				elseif context.scoring_hand[i]:is_suit('Spades') or context.scoring_hand[i].ability.effect == 'Wild Card'  then
					suits['Spades'] = suits['Spades'] + 1
				elseif context.scoring_hand[i]:is_suit('Clubs') or context.scoring_hand[i].ability.effect == 'Wild Card'  then
					suits['Clubs'] = suits['Clubs'] + 1 end
			end
		end
		
		if suits[G.GAME.fnwk_current_funky_suits[1]] > 0 and suits[G.GAME.fnwk_current_funky_suits[2]] > 0 then
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
				Xmult_mod = card.ability.extra.x_mult,
				card = context.blueprint_card or card
			}
		end
	end
end

return jokerInfo