local complex = SMODS.load_file('includes/LuaNES/libs/complex.lua')()

local band, bor, bxor, bnot, lshift, rshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.lshift, bit.rshift
local map, rotatePositiveIdx, nthBitIsSet, nthBitIsSetInt =
    UTILS.map,
    UTILS.rotatePositiveIdx,
    UTILS.nthBitIsSet,
    UTILS.nthBitIsSetInt

PALETTE = {}
local PALETTE = PALETTE

function PALETTE:defacto_palette()
    local p =
        UTILS.flat_map(
        {
            {1.00, 1.00, 1.00}, -- default
            {1.00, 0.80, 0.81}, -- emphasize R
            {0.78, 0.94, 0.66},
            -- emphasize G
            {0.79, 0.77, 0.63}, -- emphasize RG
            {0.82, 0.83, 1.12}, -- emphasize B
            {0.81, 0.71, 0.87}, -- emphasize RB
            {0.68, 0.79, 0.79}, -- emphasize GB
            {0.70, 0.70, 0.70} -- emphasize RGB
        },
        function(t)
            local rf, gf, bf = t[1], t[2], t[3]
            -- RGB default palette (I don't know where this palette came from)
            return UTILS.map(
                {
                    0x6B90A6,
                    0x3963AD,
                    0x3645A1,
                    0x624E90,
                    0x784A9C,
                    0xA8436B,
                    0xC14B44,
                    0x6B4C2D,
                    0x816B3A,
                    0x64825C,
                    0x4C7968,
                    0x00675E,
                    0x0082D5,
                    0x3A4965,
                    0x484E63,
                    0x4F6367,

                    0xDCDCDC,
                    0x4885DA,
                    0x5766C5,
                    0x836FB2,
                    0xA471BC,
                    0xCA59B5,
                    0xFD5F55,
                    0xAB5F13,
                    0xC1B142,
                    0x7EA373,
                    0x508E76,
                    0x21827C,
                    0x4CA6CC,
                    0x425153,
                    0x4F6367,
                    0x4F6367,

                    0xFFFEFF,
                    0x5EB1F8,
                    0xA6A5F3,
                    0x9C86CE,
                    0xBA82D5,
                    0xEA94EE,
                    0xFFA7A2,
                    0xFFBB42,
                    0xFBDB41,
                    0x92AC63,
                    0x56A786,
                    0x449D95,
                    0x1FD5FF,
                    0x8D88BA,
                    0x4F6367,
                    0x4F6367,

                    0xFFFEFF ,
                    0xDFF2FD,
                    0xCFCEFF,
                    0xEBCEFF,
                    0xFBD5FF,
                    0xF4C4F3,
                    0xFFE5E3,
                    0xFDE5B8,
                    0xFFF6C2,
                    0xEBFF95,
                    0x8EE2C0,
                    0xCDF8F5,
                    0xE6FAFF,
                    0xCFD1D5,
                    0x4F6367,
                    0x4F6367
                     
                },
                function(rgb)
                    local r = math.min(math.floor(band(rshift(rgb, 16), 0xff) * rf), 0xff)
                    local g = math.min(math.floor(band(rshift(rgb, 8), 0xff) * gf), 0xff)
                    local b = math.min(math.floor(band(rshift(rgb, 0), 0xff) * bf), 0xff)
                    return {r, g, b}
                end
            )
        end
    )
    return p
end

-- Nestopia generates a palette systematically (cool!), but it is not compatible with nes-tests-rom
function PALETTE:nestopia_palette()
    return UTILS.map(
        range(0, 511),
        function(n)
            local tint, level, color = band(rshift(n, 6), 7), band(rshift(n, 4), 3), band(n, 0x0f)
            local t = ({{-0.12, 0.40}, {0.00, 0.68}, {0.31, 1.00}, {0.72, 1.00}})[level + 1]
            local level0, level1 = t[1], t[2]
            if color == 0x00 then
                level0 = level1
            end
            if color == 0x0d then
                level1 = level0
            end
            if color >= 0x0e then
                level0 = 0
                level1 = 0
            end
            local y = (level1 + level0) * 0.5
            local s = (level1 - level0) * 0.5
            local iq = complex.convpolar(s, math.pi / 6 * (color - 3))
            if tint ~= 0 and color <= 0x0d then
                if tint == 7 then
                    y = (y * 0.79399 - 0.0782838) * 1.13
                else
                    level1 = (level1 * (1 - 0.79399) + 0.0782838) * 0.5
                    y = y - level1 * 0.5
                    if tint == 3 or tint == 5 or tint == 6 then
                        level1 = level1 * 0.6
                        y = y - level1
                    end
                    iq = iq + complex.convpolar(level1, math.pi / 12 * (({0, 6, 10, 8, 2, 4, 0, 0})[tint + 1]) * 2 - 7)
                end
            end
            return UTILS.map(
                {{105, 0.570}, {251, 0.351}, {15, 1.015}},
                function(pair)
                    local angle, gain = pair[1], pair[2]

                    local clr =
                        y + ((complex.convpolar(gain * 2, (angle - 33) * math.pi / 180) * complex.conjugate(iq))[1])
                    return math.min(math.max(0, math.floor(clr * 255)), 255)
                end
            )
        end
    )
end
