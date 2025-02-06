SMODS.Enhancement:take_ownership('m_lucky',
	{
		loc_vars = function(self, info_queue, card)
			-- Add tooltips by appending to info_queue
			-- all keys in this return table are optional
			local normal = G.GAME.lucky_cancels and 0 or G.GAME.probabilities.normal
			return {
				vars = {
					normal,
					self.config.mult,
					5,
					self.config.p_dollars,
					15,
				},
			}
		end,
	},
	true
)

local jokerInfo = {
	name = 'Pinstripe Joker',
	config = {
        extra = {
            lucky_tally = 0
        }
    },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'streetlight',
}

function jokerInfo.add_to_deck(self, card)
    if G.GAME.lucky_cancels then
        G.GAME.lucky_cancels = G.GAME.lucky_cancels + 1
    else
        G.GAME.lucky_cancels = 1
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    card.ability.extra.lucky_tally = 0
    if G.playing_cards then 
        for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_lucky then 
                card.ability.extra.lucky_tally = card.ability.extra.lucky_tally + 1
            end
        end
    end
        
    return { vars = {card.ability.extra.lucky_tally}}
end

function jokerInfo.calc_dollar_bonus(self, card)
    card.ability.extra.lucky_tally = 0
    if G.playing_cards then 
        for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_lucky then 
                card.ability.extra.lucky_tally = card.ability.extra.lucky_tally + 1
            end
        end
    end

    return card.ability.extra.lucky_tally
end

function jokerInfo.remove_from_deck(self, card)
    if G.GAME.lucky_cancels then
        G.GAME.lucky_cancels = G.GAME.lucky_cancels - 1
        if G.GAME.lucky_cancels <= 0 then
            G.GAME.lucky_cancels = nil
        end
    end
end

return jokerInfo