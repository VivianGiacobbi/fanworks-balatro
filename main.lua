JoJoFanworks = SMODS.current_mod
JoJoFanworks.current_config = copy_table(JoJoFanworks.config)
JoJoFanworks.calculate = function(self, context)
    if context.pseudorandom_result then
        check_for_unlock({type = 'fnwk_rand_result', result = context.result})
        return
    elseif context.card_added then
        check_for_unlock({type = 'fnwk_card_added', card = context.card})
    elseif context.removed_card then
        check_for_unlock({type = 'fnwk_card_removed', card = context.removed_card})
    elseif context.selling_card then
        check_for_unlock({type = 'fnwk_card_sold', card = context.card})
    end
end


SMODS.optional_features.quantum_enhancements = true

ArrowAPI.misc.add_colors({
	['FANWORKS'] = copy_table(JoJoFanworks.badge_colour),
	['CRYSTAL'] = HEX('B5FFFF'),
    ['STREETLIGHT'] = HEX('139194'),
    ['FNWK_ACH_RARE_1'] = HEX('6FDCB0'),
    ['FNWK_ACH_RARE_2'] = HEX('FFA551'),
    ['FNWK_ACH_RARE_3'] = HEX('FFD654'),
    ['FNWK_ACH_RARE_4'] = HEX('E096F2'),
})

ArrowAPI.ui.add_badge_colors(JoJoFanworks, {
    co_fanworks = HEX('DD85B4'),
    te_fanworks = HEX('FFFFFF'),
    co_streetlight = HEX('139194'),
    te_streetlight = HEX('FFFFFF'),
    co_bluebolt = HEX('3BC2EF'),
    te_bluebolt = HEX('FFFFFF'),
    co_moscow = HEX('44AA6C'),
    te_moscow = HEX('FFFFFF'),
    co_sunshine = HEX('FF3C00'),
    te_sunshine = HEX('FFFFFF'),
    co_rockhard = HEX('8DDDEF'),
    te_rockhard = HEX('FFFFFF'),
    co_rubicon = HEX('EFD407'),
    te_rubicon = HEX('FFFFFF'),
    co_gotequest = HEX('DD638A'),
    te_gotequest = HEX('FFFFFF'),
    co_jojopolis = HEX('D56F15'),
    te_jojopolis = HEX('FFFFFF'),
    co_spirit = HEX('FF60FF'),
    te_spirit = HEX('FFFFFF'),
    co_closer = HEX('D4AF37'),
    te_closer = HEX('FFFFFF'),
    co_industry = HEX('CA4ED3'),
    te_industry = HEX('FFFFFF'),
    co_double = HEX('1956FF'),
    te_double = HEX('FFFFFF'),
    co_love = HEX('E7B2D4'),
    te_love = HEX('FFFFFF'),
    co_coi = HEX('FFFFFF'),
    te_coi = HEX('365156'),
    co_iron = HEX('FF2828'),
    te_iron = HEX('FFFFFF'),
    co_lighted = HEX('90EF58'),
    te_lighted = HEX('FFFFFF'),
    co_asap = HEX('9818BD'),
    te_asap = HEX('FFFFFF'),
    co_bone = HEX('EEDC99'),
    te_bone = HEX('FFFFFF'),
    co_crimson = HEX('FFB74B'),
    te_crimson = HEX('FFFFFF'),
    co_culture = HEX('3690FF'),
    te_culture = HEX('FFFFFF'),
    co_jspec = HEX('3A5055'),
    te_jspec = HEX('FFFFFF'),
    co_noman = HEX('EB9C58'),
    te_noman = HEX('FFFFFF'),
    co_last = HEX('E8A686'),
    te_last = HEX('FFFFFF'),
    co_mania = HEX('CC3366'),
    te_mania = HEX('FFFFFF'),
    co_careless = HEX('BF5532'),
    te_careless = HEX('FFFFFF'),
    co_city = HEX('A3AEFF'),
    te_city = HEX('FFFFFF'),
    co_glass = HEX('B1FFE6'),
    te_glass = HEX('FFFFFF'),
    co_scepter = HEX('E74C3C'),
    te_scepter = HEX('FFFFFF'),
    co_apocryphal = HEX('DE0155'),
    te_apocryphal = HEX('FFFFFF'),
    co_stalk = HEX('86C09B'),
    te_stalk = HEX('FFFFFF'),
    co_neon = HEX('900000'),
    te_neon = HEX('FFFFFF'),
    co_thorny = HEX('D4D4D4'),
    te_thorny = HEX('365156'),
    co_golden = HEX('BC9E49'),
    te_golden = HEX('FFFFFF'),
    co_mdv = HEX('AD3088'),
    te_mdv = HEX('FFFFFF'),
    co_jojojidai = HEX('27407C'),
    te_jojojidai = HEX('FFFFFF'),
    co_lipstick = HEX('8B2939'),
    te_lipstick = HEX('FFFFFF'),
    co_cis = HEX('DEF7FB'),
    te_cis = HEX('5BA1B2'),
    co_yym = HEX('0D8640'),
    te_yym = HEX('FFFFFF'),
    co_rebels = HEX('FF6DDC'),
    te_rebels = HEX('FFFFFF'),
    co_redrising = HEX('7F1010'),
    te_redrising = HEX('FFFFFF'),
    co_rockn = HEX('FF8989'),
    te_rockn = HEX('FFFFFF'),
    co_dark = HEX('5A4385'),
    te_dark = HEX('FFFFFF'),
    co_voodoo = HEX('CDCBE4'),
    te_voodoo = HEX('EAA812'),
    co_upto0 = HEX('475641'),
    te_upto0 = HEX('FF3C38'),
    co_paper = HEX('FFFFFF'),
    te_paper = HEX('F75F64'),
})

ArrowAPI.config.use_credits(JoJoFanworks, {
    matrix = {col = 21, row = 10},
    {
        key = 'direction',
        title_colour = G.C.YELLOW,
        pos_start = {col = 0, row = 0},
        pos_end = {col = 4.5, row = 10},
        contributors = {
            {name = "BarrierTrio/Gote", name_scale = 1.1},
            {name = "Vivian Giacobbi", name_scale = 1.1},
        }
    },
    {
        key = 'artist',
        title_colour = G.C.ETERNAL,
        pos_start = {col = 4.5, row = 0},
        pos_end = {col = 12, row = 10}
    },
    {
        key = 'programmer',
        title_colour = G.C.GOLD,
        pos_start = {col = 12, row = 0},
        pos_end = {col = 16.5, row = 6},
        contributors = {
            {name = "BarrierTrio/Gote", name_scale = 0.85},
            {name = "Kekulism", name_scale = 0.85},
            {name = "Vivian Giacobbi", name_scale = 0.85},
        }
    },
    {
        key = 'graphics',
        title_colour = G.C.DARK_EDITION,
        pos_start = {col = 16.5, row = 0},
        pos_end = {col = 21, row = 6},
        contributors = {
            {name = "Vivian Giacobbi"},
        }
    },
    {
        key = 'special',
        title_colour = G.C.GREEN,
        pos_start = {col = 12, row = 6},
        pos_end = {col = 21, row = 10},
        contributors = {
            {name = "Hirohiko Araki", name_scale = 1.75},
            {name = "LuckyLand Communications", name_scale = 1.75},
            {name = "Nico Abrams (LuaNES)", name_scale = 1.75},
        }
    },
})

local includes = {
	-- includes utility functions required for following files
	'emulator',
	'tables',
	'colors',
	'utility',
	'shaders',

	-- object hooks
	'hooks/common_events',
	'hooks/state_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/button_callbacks',
	'hooks/uielement',
	'hooks/game',
	'hooks/card',
	'hooks/cardarea',
	'hooks/blind',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first
	'ui',
	'items',
    'deckskins',
	'tarot_reskins',
	'blind_reskins',
	'overrides',
}

for _, module in ipairs(includes) do
	local init, error = NFS.load(JoJoFanworks.path .. "includes/" .. module ..".lua")
	if error then sendErrorMessage("[Fanworks] Failed to load "..module.." with error "..error) else
		local data = init()
		sendDebugMessage("[Fanworks] Loaded module: " .. module)
	end
end