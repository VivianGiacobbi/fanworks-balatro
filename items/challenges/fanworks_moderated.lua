local chalInfo = {
    rules = {
        custom = {
            {
                id = 'extra_blind_active',
                value = {type = 'name_text', key = 'bl_final_heart', set = 'Blind'},
                colours = {{ref_table = G.P_BLINDS, ref_key = 'bl_final_heart', ref_value = 'boss_colour'}}
            }
        }
    },
    vouchers = {
        { id = 'v_fnwk_rubicon_kitty'},
        { id = 'v_fnwk_rubicon_parade'}
    },
    unlocked = function(self)
        return G.P_CENTERS['v_fnwk_rubicon_kitty'].discovered and G.P_CENTERS['v_fnwk_rubicon_parade'].discovered
    end,
    extra_blinds = {
        'bl_final_heart',
    },
    restrictions = {
        banned_cards = {
            {id = 'j_perkeo'},
            {id = 'c_fnwk_rockhard_quadro'},
            {id = 'c_fnwk_jspec_miracle_together'},
            {id = 'c_ectoplasm'},
            {id = 'e_negative'}
        },
        banned_tags = {
            {id = 'tag_negative'}
        },
        banned_other = {
            {id = 'bl_final_heart', type = 'blind'}
        }
    },
    programmer = 'Vivian Giacobbi',
}

return chalInfo