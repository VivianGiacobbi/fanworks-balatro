local ref_alert_debuff = Blind.alert_debuff
function Blind:alert_debuff(...)
	if self.config.blind.key == 'bl_fnwk_final_moe' then return end
	return ref_alert_debuff(self, ...)
end