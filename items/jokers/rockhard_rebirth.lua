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
	fanwork = 'rockhard',
    alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
    return { vars = {G.GAME.probabilities.normal, card.ability.extra} }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_wild') then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers and not card.debuff then
        local tick_cards = {}
        for i = 1, #context.scoring_hand do
            local enhancements = SMODS.get_enhancements(context.scoring_hand[i])
            if enhancements['m_wild'] and pseudorandom(pseudoseed('rebirth')) < G.GAME.probabilities.normal/card.ability.extra then
                tick_cards[#tick_cards+1] = context.scoring_hand[i]
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