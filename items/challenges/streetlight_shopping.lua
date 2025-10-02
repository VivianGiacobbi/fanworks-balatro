local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_crimson_manager'},
            {id = 'fnwk_crimson_manager_2'},
            {id = 'no_shop_jokers'},
        },
        modifiers = {
            {id = 'joker_slots', value = 0},
        }
    },
    config = { 
        world_rate = 6
    },
    on_apply = function(challenge)
        G.GAME.fnwk_stand_world_rate = challenge.config.world_rate
    end,
    jokers = {
        { id = 'j_fnwk_fanworks_jogarc', eternal = true },
        { id = 'j_fnwk_fanworks_jogarc', eternal = true },
        { id = 'j_diet_cola'},
        { id = 'j_diet_cola'},
        { id = 'j_fnwk_streetlight_arrow' },
    },
    consumeables = {
        { id = 'c_fnwk_spec_mood' },
        { id = 'c_fnwk_spec_mood' }
    },
    vouchers = {
        { id = 'v_crystal_ball' }
    },
    restrictions = {
        banned_cards = {
            {id = 'j_riff_raff' },
            {id = 'j_invisible' },
            {id = 'j_fnwk_fanworks_jester' },
            {id = 'c_judgement' },
            {id = 'c_wraith' },
            {id = 'c_soul' },
            {id = 'v_blank' },
            {id = 'v_antimatter'},
            {id = 'v_fnwk_rubicon_kitty'},
            {id = 'v_fnwk_rubicon_parade'},
            {id = 'v_fnwk_streetlight_waystone'},
            {id = 'v_fnwk_streetlight_binding'},
            {id = 'p_buffoon_normal_1', ids = {
                'p_buffoon_normal_1','p_buffoon_normal_2','p_buffoon_jumbo_1','p_buffoon_mega_1',
            }},
        },
        banned_tags = {
            {id = 'tag_rare'},
            {id = 'tag_uncommon'},
            {id = 'tag_holo'},
            {id = 'tag_polychrome'},
            {id = 'tag_negative'},
            {id = 'tag_foil'},
            {id = 'tag_buffoon'},
            {id = 'tag_top_up'},
            {id = 'tag_fnwk_biased'}
        }
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    }
}

return chalInfo