local jokerInfo = {
	name = 'Moonglass Crossed Joker',
	config = {
        extra = 3
    },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rubicon',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cream", set = "Other"}
    return { vars = {G.GAME.probabilities.normal, card.ability.extra}}
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before then
        local glassed = 0
        for k, v in ipairs(context.scoring_hand) do
            if v:is_suit('Spades') and pseudorandom('rubicon_bone') < G.GAME.probabilities.normal/card.ability.extra then 
                glassed = glassed + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:set_ability(G.P_CENTERS.m_glass, nil, false)
                        v:juice_up()
                        return true
                    end
                })) 
            end
        end
        if glassed > 0 then
            return {
                message = localize('k_glass_ex'),
                sound = 'highlight2',
                colour = G.C.GREY,
                card = card
            } 
        end
    end
end

return jokerInfo