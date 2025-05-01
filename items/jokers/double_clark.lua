local jokerInfo = {
	name = 'Acerbic Fencer',
	config = {
        extra = {}
    },
	rarity = 1,
	cost = 4,
    unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'double',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
end

function jokerInfo.check_for_unlock(self, args)
    if not G.playing_cards then
        return false
    end
    
    if not args or args.type ~= 'queen_to_king' then
        return false
    end

    return true
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint then
        return
    end
    
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
                local juice_card = context.blueprint_card or card
                juice_card:juice_up()
                return true
            end}))

        playing_card_joker_effects({true})
    end
end

return jokerInfo