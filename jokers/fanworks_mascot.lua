local jokerInfo = {
    key = 'j_fnwk_fanworks_mascot',
	name = 'Server Mascot',
	config = {},
	rarity = 2,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
    if context.check_enhancement and context.cardarea == G.jokers then
		if context.other_card.config.center.key == 'm_lucky' then
            return {
                ['m_glass'] = true,
            }
        elseif context.other_card.config.center.key == 'm_glass' then
            return {
                ['m_lucky'] = true,
            }
        end
	end 
end

return jokerInfo