local ref_alert_debuff = Blind.alert_debuff
function Blind:alert_debuff(...)
	if self.config.blind.key == 'bl_fnwk_final_moe' then return end
	return ref_alert_debuff(self, ...)
end

local ref_blind_debuff = Blind.debuff_card
function Blind:debuff_card(card, from_blind)
    if card.config.center.key ~= 'c_fnwk_crimson_fortunate' or card.debuff then
        return ref_blind_debuff(self, card, from_blind)
    end

    local ret = ref_blind_debuff(self, card, from_blind)
    if card.debuff then
        check_for_unlock({type = 'fnwk_crimson_american'})
    end
    return ret
end