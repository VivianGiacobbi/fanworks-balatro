local deckInfo = {
    name = 'Wheel Deck',
    config = {},
    unlocked = false,
    discovered = false,
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
    end,
    unlock_condition = {type = 'win_deck', deck = 'b_fnwk_vine'},
}

deckInfo.calculate = function(self, card, context)
    if context.end_of_round and G.GAME.blind.boss and not context.other_card then
        G.E_MANAGER:add_event(Event({
            func = function()
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    local _card = create_card('VHS', G.consumeables, nil, nil, nil, nil, 'c_fnwk_blackspine', 'car')
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                    G.GAME.consumeable_buffer = 0
                end
                return true
            end }))
    end
end

return deckInfo