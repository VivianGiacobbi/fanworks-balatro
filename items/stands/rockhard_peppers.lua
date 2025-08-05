local consumInfo = {
	name = "Sgt Pepper's",
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '68BC9ADC', '5176B0DC' },
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'cringe',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_wild
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.retrigger_joker or context.debuff then return end 

    if context.check_enhancement and not (context.other_card.area == G.deck or context.other_card.area == G.discard) then
		if context.other_card.config.center.key ~= 'c_base' then
            return {
                ['m_wild'] = true,
            }
        end
	end 
end

return consumInfo