local jokerInfo = {
	name = 'Rebirth of the Flesh',
	config = {
        extra = 3
    },
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'Stupisms',
    programmer = 'Vivian Giacobbi',
    alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra, 'fnwk_rockhard_rebirth')} }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_wild') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local tick_cards = {}
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_enhancement(v, 'm_wild') and
            SMODS.pseudorandom_probability(card, 'fnwk_rockhard_rebirth', 1, card.ability.extra, 'fnwk_rockhard_rebirth') then
                tick_cards[#tick_cards+1] = v
            end
        end

        local levels = #tick_cards
        if levels > 0 then
            for i = 1, levels do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.2,
                    func = function()
                        tick_cards[i]:juice_up()
                    return true
                end }))
            end
            return {
                card = context.blueprint_card or card,
                level_up = levels,
                message = localize{type = 'variable', key = 'a_multilevel', vars = {levels}},
            }
        end
    end
end

return jokerInfo