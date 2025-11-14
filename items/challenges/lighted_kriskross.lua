local chalInfo = {
    rules = {
        custom = {
            {id = "max_stands", value = 5}
        },
        modifiers = {
            {id = 'joker_slots', value = 1},
            {id = 'consumable_slots', value = 6}
        }
    },
    vouchers = {
        { id = 'v_arrow_foo'}
    },
    unlocked = function(self)
        return ArrowAPI.game.check_mod_discoveries(nil, 'Stand', self) >= 5
    end,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'lighted',
		},
        custom_color = 'lighted',
    },
    programmer = 'Vivian Giacobbi',
}

return chalInfo