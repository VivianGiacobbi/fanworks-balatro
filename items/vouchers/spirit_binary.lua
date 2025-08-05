local voucherInfo = {
    name = 'Type Binary',
    config = {
        extra = 1
    },
    cost = 10,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra}}
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.modifiers.max_stands = (G.GAME.modifiers.max_stands or 1) + card.ability.extra
            return true
        end)
    }))
end

return voucherInfo