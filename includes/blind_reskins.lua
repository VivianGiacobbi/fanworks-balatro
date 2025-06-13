if not fnwk_enabled['enableBlindReskins'] then
    sendDebugMessage('NO BLIND RESKINS')
    return
end

sendDebugMessage('ENABLING BLIND RESKINS')

-- Tarot Atlas
SMODS.Atlas{
    key = 'blind_reskins',
    path = 'blinds/blind_reskins.png',
    frames = 21,
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind:take_ownership('bl_ox', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('CC3366')}, true)
SMODS.Blind:take_ownership('bl_hook', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('36B3FF')}, true)
SMODS.Blind:take_ownership('bl_house', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('D4E3E5')}, true)
SMODS.Blind:take_ownership('bl_wall', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('900000')}, true)
SMODS.Blind:take_ownership('bl_arm', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('EEDC99')}, true)
SMODS.Blind:take_ownership('bl_club', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('9818BD')}, true)
SMODS.Blind:take_ownership('bl_fish', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('B982FF')}, true)
SMODS.Blind:take_ownership('bl_wheel', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('BF5532')}, true)
SMODS.Blind:take_ownership('bl_psychic', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('EB9C58')}, true)
SMODS.Blind:take_ownership('bl_goad', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('D56F15')}, true)
SMODS.Blind:take_ownership('bl_water', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('44AA6C')}, true)
SMODS.Blind:take_ownership('bl_window', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('A5F16B')}, true)
SMODS.Blind:take_ownership('bl_manacle', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('E74C3C')}, true)
SMODS.Blind:take_ownership('bl_eye', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('86C09B')}, true)
SMODS.Blind:take_ownership('bl_mouth', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('FF0000')}, true)
SMODS.Blind:take_ownership('bl_plant', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('B0FFE6')}, true)
SMODS.Blind:take_ownership('bl_serpent', {atlas = 'fnwk_blind_reskins'}, true)
SMODS.Blind:take_ownership('bl_pillar', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('F0D418')}, true)
SMODS.Blind:take_ownership('bl_needle', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('A4A4A4')}, true)
SMODS.Blind:take_ownership('bl_head', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('FFB74B')}, true)
SMODS.Blind:take_ownership('bl_tooth', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('FF3C00')}, true)
SMODS.Blind:take_ownership('bl_flint', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('9BA5F3')}, true)
SMODS.Blind:take_ownership('bl_mark', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('2C3D40')}, true)

SMODS.Blind:take_ownership('bl_final_acorn', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('FDA7B0')}, true)
SMODS.Blind:take_ownership('bl_final_leaf', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('059194')}, true)
SMODS.Blind:take_ownership('bl_final_vessel', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('1856FF')}, true)
SMODS.Blind:take_ownership('bl_final_heart', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('4F6367')}, true)
SMODS.Blind:take_ownership('bl_final_bell', {atlas = 'fnwk_blind_reskins', boss_colour = HEX('ADDDF0')}, true)