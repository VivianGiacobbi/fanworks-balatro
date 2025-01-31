local jokerInfo = {
	name = '1: The Aquarium',
	config = {},
	rarity = 1,
	cost = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = 'spirit_lines',
}

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not self.debuff then
		if context.scoring_name == 'Pair' then
            for k, v in ipairs(context.scoring_hand) do
				v:set_ability(G.P_CENTERS.m_steel, nil, false)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                })) 
            end
		end
	end
end

return jokerInfo