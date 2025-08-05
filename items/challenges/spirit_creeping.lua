local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_spirit_creeping' },
            {id = 'scaling', value = 2},
        },
    },
    consumeables = {
        { id = 'c_fnwk_spirit_sweet', eternal = true },
    },
    restrictions = {
        banned_cards = {
            {id = 'c_fnwk_spec_impulse' },
            {id = 'c_fnwk_spec_ichor' },
        },
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    }
}

return chalInfo