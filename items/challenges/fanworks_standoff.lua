local chalInfo = {
    rules = {
        custom = {
            {id = "max_stands", value = 2},
            {id = 'fnwk_fanworks_standoff'},
            {id = 'fnwk_fanworks_standoff_2'},
        }
    },
    consumeables = {
        {id = 'c_fnwk_random_stand', eternal = true},
        {id = 'c_fnwk_random_stand', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'j_fnwk_rockhard_vasos'},
            {id = 'c_arrow_tarot_arrow' },
            {id = 'c_arrow_spec_diary' },
            {id = 'v_crystal_ball'},
            {id = 'v_omen_globe'},
            {id = 'v_arrow_foo'},
            {id = 'v_arrow_plant'},
            {id = 'v_omen_globe'},
            {id = 'p_arrow_spirit_reg'},
        },
        banned_tags = {
            {id = 'tag_arrow_spirit'}
        }
    },
    programmer = 'Vivian Giacobbi',
}

return chalInfo