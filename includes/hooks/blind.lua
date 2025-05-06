local ref_debuff_hand = Blind.debuff_hand
function Blind:debuff_hand(cards, hand, handname, check)
	if next(SMODS.find_card('c_fnwk_sunshine_downward')) then
        sendDebugMessage('checking debuff')
        local most_played = fnwk_get_most_played_hand()
		if handname ~= most_played then
			return true
		end
	end

	return ref_debuff_hand(self, cards, hand, handname, check)
end

local ref_debuff_text = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text()
	if next(SMODS.find_card('c_fnwk_sunshine_downward')) then
        local most_played = fnwk_get_most_played_hand()
        local loc_text = localize(most_played, 'poker_hands')
        return localize{type='variable',key='downward_warn_text',vars={loc_text}}
	end
    
	return ref_debuff_text(self)
end
