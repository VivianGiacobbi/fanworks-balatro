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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'leafy',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky

    return { vars = {ArrowAPI.game.get_enhanced_tally('m_lucky')}}
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_lucky') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.fix_probability and context.seed_key == 'lucky_money' then
        return {
            numerator = 0
        }
    end
end

function jokerInfo.calc_dollar_bonus(self, card)
    local tally = ArrowAPI.game.get_enhanced_tally('m_lucky')
    if tally > 0 then
        return tally
    end
end

return jokerInfo