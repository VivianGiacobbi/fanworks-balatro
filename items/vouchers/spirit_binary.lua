local voucherInfo = {
    name = 'Type Binary',
    config = {
        extra = 1
    },
    cost = 10,
    fanwork = 'spirit',
    dependencies = {'ArrowAPI'},
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra}}
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.starting_params.max_stands = (G.GAME.starting_params.max_stands or 1) + card.ability.extra
            return true
        end)
    }))
end

return voucherInfo