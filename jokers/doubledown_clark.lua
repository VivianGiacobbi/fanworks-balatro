local jokerInfo = {
	name = 'Acerbic Fencer',
	config = {
        extra = {}
    },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'doubledown',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
    if context.first_hand_drawn then
        G.E_MANAGER:add_event(Event({
            func = function() 
                local _card = create_playing_card({
                    front = pseudorandom_element(G.P_CARDS, pseudoseed('iluclark')), 
                    center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                local _rank = pseudorandom_element({'J','Q','K'}, pseudoseed('clarkbestboy'))
                local suit_prefix = string.sub(_card.base.suit, 1, 1)..'_'
                local rank_suffix =_rank
                _card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                G.GAME.blind:debuff_card(_card)
                G.hand:sort()
                --if context.blueprint_card then context.blueprint_card:juice_up() else self:juice_up() end
                return true
            end}))

        playing_card_joker_effects({true})
    end
end

return jokerInfo