local consumInfo = {
	name = "Sgt Pepper's",
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { '68BC9ADC', '5176B0DC' },
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rockhard',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
end

function consumInfo.calculate(self, card, context)
	if context.blueprint then return end
    if context.check_enhancement and context.cardarea == G.jokers then
		if context.other_card.ability.effect ~= "Base" then
            return {
                ['m_wild'] = true,
            }
        end
	end 
end

return consumInfo