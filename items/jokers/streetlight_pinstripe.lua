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
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
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
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.leafy }}
        
    return { vars = {fnwk_get_enhanced_tally('m_lucky')}}
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_lucky') then
            return true
        end
    end
end

function jokerInfo.calc_dollar_bonus(self, card)
    local tally = fnwk_get_enhanced_tally('m_lucky')
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