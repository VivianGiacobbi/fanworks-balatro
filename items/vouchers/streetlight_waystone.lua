local voucherInfo = {
    name = 'Waystone',
    config = {},
    cost = 10,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist  = 'Leafgilly',
    programmer = 'Vivian Giacobbi',
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