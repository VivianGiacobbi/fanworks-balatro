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
        extra = {},
    },
	rarity = 3,
	cost = 12,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'streetlight',
}

local function get_lucky_tally()
    local lucky_tally = 0

    if not G.playing_cards then
        return lucky_tally
    end
    if G.playing_cards then 
        for k, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_lucky') then 
                lucky_tally =  lucky_tally + 1
            end
        end
    end

    return lucky_tally
end

function jokerInfo.add_to_deck(self, card)
    if G.GAME.lucky_cancels then
        G.GAME.lucky_cancels = G.GAME.lucky_cancels + 1
    else
        G.GAME.lucky_cancels = 1
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "artist_leafy", set = "Other"}
        
    return { vars = {get_lucky_tally()}}
end

function jokerInfo.calc_dollar_bonus(self, card)
    local tally = get_lucky_tally()
    if tally > 0 then
        return tally
    end
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