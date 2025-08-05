local chalInfo = {
    rules = {
        custom = {
            {
                id = 'extra_blind_active',
                value = {type = 'name_text', key = 'bl_fnwk_written', set = 'Blind'},
                colours = {{ref_table = G.P_BLINDS, ref_key = 'bl_fnwk_written', ref_value = 'boss_colour'}}
            },
            {
                id = 'extra_blind_active',
                value = {type = 'name_text', key = 'bl_fnwk_manga', set = 'Blind'},
                colours = {{ref_table = G.P_BLINDS, ref_key = 'bl_fnwk_manga', ref_value = 'boss_colour'}}
            },
            {
                id = 'extra_blind_active',
                value = {type = 'name_text', key = 'bl_fnwk_final_multimedia', set = 'Blind'},
                colours = {{ref_table = G.P_BLINDS, ref_key = 'bl_fnwk_final_multimedia', ref_value = 'boss_colour'}}
            }
        }
    },
    extra_blinds = {
        'bl_fnwk_written',
        'bl_fnwk_manga',
        'bl_fnwk_final_multimedia'
    },
}

return chalInfo