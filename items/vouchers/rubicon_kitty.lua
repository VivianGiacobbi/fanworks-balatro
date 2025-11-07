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
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'CreamSodaCrossroads',
    programmer = 'Vivian Giacobbi',
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
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