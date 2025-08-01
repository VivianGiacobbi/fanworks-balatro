local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_consumable_save"},
            {id = "fnwk_play_save"},
            {id = "fnwk_all_scores_hidden"},
        },
        modifiers = {
            {id = 'consumable_slots', value = 5},
        }
    },
    consumeables = {
        {id = 'c_fnwk_spirit_achtung_stranger', eternal = true}
    },
    vouchers = {
        {id = 'v_overstock_norm'},
        {id = 'v_overstock_plus'},
        {id = 'v_tarot_merchant'},
        {id = 'v_tarot_tycoon'},
    },
    restrictions = {
        banned_cards = {
            {id = 'j_fnwk_streetlight_industrious'},
            {id = 'c_jojobal_diamond_echoes_2'},
            {id = 'c_jojobal_lands_november'},
            {id = 'c_jojobal_lands_bigmouth'},
            {id = 'c_fnwk_last_tragic'},
            {id = 'c_fnwk_rubicon_infidelity'},
        },
    }
}

return chalInfo