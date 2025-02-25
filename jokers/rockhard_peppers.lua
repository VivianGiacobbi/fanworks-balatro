local jokerInfo = {
	name = "Sgt Pepper's",
	config = {
        extra = 3
    },
	rarity = 3,
	cost = 10,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
    if context.check_enhancement and context.cardarea == G.jokers then
		if context.other_card.ability.effect ~= "Base" then
            return {
                ['m_wild'] = true,
            }
        end
	end 
end

return jokerInfo