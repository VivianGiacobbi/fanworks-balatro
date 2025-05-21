local consumInfo = {
	name = "Sgt Pepper's",
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '68BC9ADC', '5176B0DC' },
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rockhard',
    in_progress = true,
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.debuff then return end 

    if context.check_enhancement and not (context.other_card.area == G.deck or context.other_card.area == G.discard) then
		if context.other_card.config.center.key ~= 'c_base' then
            return {
                ['m_wild'] = true,
            }
        end
	end 
end

return consumInfo