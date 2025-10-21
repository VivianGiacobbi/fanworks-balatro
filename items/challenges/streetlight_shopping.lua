local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_no_money'},
            {id = 'fnwk_no_sell'},
            {id = 'no_reward'},
            {id = 'no_extra_hand_money'},
            {id = 'no_interest'}
        },
        modifiers = {
            {id = 'dollars', value = 200},
        }
    },
    jokers = {
        { id = 'j_fnwk_streetlight_indulgent', eternal = true },
    },
    consumeables = {
        { id = 'c_fnwk_streetlight_neon_favorite', eternal = true },
    },
    unlocked = function(self)
        return G.P_CENTERS['j_fnwk_streetlight_indulgent'].discovered and G.P_CENTERS['c_fnwk_streetlight_neon_favorite'].discovered
    end,
    vouchers = {
        { id = 'v_overstock_norm' },
        { id = 'v_overstock_norm' },
        { id = 'v_clearance_sale' },
        { id = 'v_liquidation' },
        { id = 'v_reroll_surplus' },
        { id = 'v_reroll_glut' }
    },
    restrictions = {
        banned_cards = {
            {id = 'j_business' },
            {id = 'j_egg' },
            {id = 'j_faceless' },
            {id = 'j_todo_list' },
            {id = 'j_cloud_9' },
            {id = 'j_rocket' },
            {id = 'j_gift' },
            {id = 'j_reserved_parking'},
            {id = 'j_mail'},
            {id = 'j_to_the_moon'},
            {id = 'j_golden'},
            {id = 'j_ticket'},
            {id = 'j_swashbuckler'},
            {id = 'j_rough_gem'},
            {id = 'j_satellite'},
            {id = 'j_fnwk_gotequest_lambiekins'},
            {id = 'j_fnwk_streetlight_cabinet'},
            {id = 'j_fnwk_golden_generation'},
            {id = 'c_hermit'},
            {id = 'c_temperance'},
            {id = 'c_talisman'},
            {id = 'c_immolate'},
            {id = 'gold_seal'},
        },
        banned_tags = {
            {id = 'tag_investment'},
            {id = 'tag_skip'},
            {id = 'tag_economy'},
        },
        banned_other = {
            {id = 'bl_ox', type = 'blind'}
        }
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    }
}

return chalInfo