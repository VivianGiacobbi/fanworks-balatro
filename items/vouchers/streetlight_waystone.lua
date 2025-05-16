local voucherInfo = {
    name = 'Waystone',
    config = {},
    cost = 10,
    fanwork = 'streetlight'
}

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.fnwk_waystone_ante = G.GAME.round_resets.ante
            return true
        end)
    }))
end

return voucherInfo