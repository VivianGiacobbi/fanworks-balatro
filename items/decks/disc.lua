local deckInfo = {
    name = 'DISC Deck',
    config = {},
    unlocked = false,
    discovered = false,
    config = {
        vouchers = {
            'v_overstock_norm',
        },
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
    end,
    unlock_condition = {type = 'win_deck', deck = 'b_green'}
}

function deckInfo.apply(self, back)
    -- unclear stand code
    --[[
    if G.GAME.selected_back.effect.center.key == "b_fnwk_disc" then
        G.GAME.unlimited_stands = true
    end
    G.GAME.max_stands = G.GAME.modifiers.max_stands or 1
    --]]
end

return deckInfo