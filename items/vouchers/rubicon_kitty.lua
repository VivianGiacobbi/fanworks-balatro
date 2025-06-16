SMODS.Edition:take_ownership('e_negative', {
        get_weight = function(self)
            return (G.GAME.negative_rate or 1) * self.weight
        end,
    }, true
)

local voucherInfo = {
    name = 'Demon Kitty',
    config = {
        extra = 2
    },
    cost = 10,
    fanwork = 'rubicon'
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cream }}
    return { vars = {card.ability.extra}}
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.negative_rate = G.GAME.negative_rate * card.ability.extra
            return true
        end)
    }))
end

return voucherInfo