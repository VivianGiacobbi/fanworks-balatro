--- A table of joker keys considered "women"
G.fnwk_women = {
    get_from_key = function(key)
        local junkie = G.fnwk_women.junkies[key]
        local trans = G.fnwk_women.trans[key]
        local woman = G.fnwk_women.women[key]
        local girl = G.fnwk_women.girls[key]
        return {junkie = junkie, trans = trans, woman = woman, girl = girl}
    end,
    women = {
        ['j_lusty_joker'] = true,
        ['j_blueprint'] = true,
        ['j_brainstorm'] = true,
        ['j_shoot_the_moon'] = true,
        ['j_fnwk_plancks_unsure'] = true,
        ['j_fnwk_rubicon_moonglass'] = true,
        ['j_fnwk_streetlight_fledgling'] = true,
        ['j_fnwk_streetlight_indulgent'] = true,
        ['j_fnwk_streetlight_industrious'] = true,
        ['j_fnwk_streetlight_methodical'] = true,
        ['j_fnwk_rubicon_thnks'] = true,
        ['j_fnwk_streetlight_resil'] = true,
        ['j_fnwk_bone_destroyer'] = true,
        ['j_fnwk_industry_loyal'] = true,
        ['j_fnwk_mania_jokestar'] = true,
        ['j_fnwk_gotequest_killing'] = true,
        ['j_fnwk_jspec_joepie'] = true,
        ['j_fnwk_jspec_ilsa'] = true,
        ['j_fnwk_bluebolt_tuned'] = true,
        ['j_fnwk_love_holy'] = true,
    },
    trans = {
        ['j_drivers_license'] = true,
        ['j_fnwk_rockhard_rebirth'] = true,
        ['j_fnwk_bluebolt_sexy'] = true,
        ['j_fnwk_bluebolt_secluded'] = true
    },
    girls = {
        ['j_fnwk_plancks_ghost'] = true,
        ['j_fnwk_glass_jokestar'] = true,
        ['j_fnwk_love_jokestar'] = true,
    },
    junkies = {
        ['j_fnwk_gotequest_lambiekins'] = 2,
        ['j_egg'] = 1,
        ['j_fnwk_bluebolt_secluded'] = 1,
        ['j_fnwk_bluebolt_tuned'] = 1,
        ['j_fnwk_bluebolt_jokestar'] = 1,
        ['j_fnwk_bluebolt_sexy'] = 1,
        ['j_fnwk_bluebolt_impaired'] = 1,
    }
}





---------------------------
--------------------------- Scaling detection behavior
---------------------------

G.fnwk_valid_scaling_keys = {
	['mult'] = true,
	['h_mult'] = true,
	['h_x_mult'] = true,
	['h_dollars'] = true,
	['p_dollars'] = true,
	['t_mult'] = true,
	['t_chips'] = true,
	['x_mult'] = true,
	['h_chips'] = true,
	['x_chips'] = true,
	['h_x_chips'] = true,
	['h_size'] = true,
	['d_size'] = true,
	['extra_value'] = true,
	['perma_bonus'] = true,
	['perma_x_chips'] = true,
	['perma_mult'] = true,
	['perma_x_mult'] = true,
	['perma_h_chips'] = true,
	['perma_h_mult'] = true,
	['perma_h_x_mult'] = true,
	['perma_p_dollars'] = true,
	['perma_h_dollars'] = true,
	['caino_xmult'] = true,
	['yorick_discards'] = true,
	['invis_rounds'] = true
}





---------------------------
--------------------------- Obscure suit information
---------------------------

G.fnwk_obscure_suits = {
    { key = 'Arrows', row_pos = 0},
    { key = 'Masks', row_pos = 1},
    { key = 'Stars', row_pos = 2},
    { key = 'Crosses', row_pos = 3}
}

G.fnwk_obscure_suit_colors = {
    HEX('CC3366'),
    HEX('36B3FF'),
    HEX('D4E3E5'),
    HEX('900000'),
    HEX('EEDC99'),
    HEX('9818BD'),
    HEX('B982FF'),
    HEX('BF5532'),
    HEX('EB9C58'),
    HEX('D56F15'),
    HEX('44AA6C'),
    HEX('A5F16B'),
    HEX('E74C3C'),
    HEX('86C09B'),
    HEX('FF0000'),
    HEX('B0FFE6'),
    HEX('E8A686'),
    HEX('F0D418'),
    HEX('A4A4A4'),
    HEX('FFB74B'),
    HEX('FF3C00'),
    HEX('9BA5F3'),
    HEX('2C3D40'),
    HEX('FDA7B0'),
    HEX('059194'),
    HEX('1856FF'),
    HEX('4F6367'),
    HEX('ADDDF0'),
    HEX('6FD0F2'),
    HEX('C2CDDF'),
    HEX('A0DAB2'),
    HEX('F3CF58'),
    HEX('4E77E0'),
    HEX('FD5F55'),
    HEX('B482E0'),
    HEX('E078A0'),
    HEX('E86EB5'),
    HEX('DD85B4'),
    HEX('CECEC4'),
}
