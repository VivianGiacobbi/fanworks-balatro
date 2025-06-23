fnwk_config = SMODS.current_mod.config
fnwk_enabled = copy_table(fnwk_config)

local csau = next(SMODS.find_mod('Cardsauce'))
local stands = next(SMODS.find_mod('ArrowAPI'))

if csau or stands then
	G.fnwk_stands_enabled = true
end

-- force set these to false
if not G.fnwk_stands_enabled then
	fnwk_config['standsEnabled'] = false
	fnwk_enabled['standsEnabled'] = false
end

SMODS.optional_features.quantum_enhancements = true

G.C.FANWORKS = SMODS.current_mod.badge_colour
G.C.CRYSTAL = HEX('B5FFFF')

local includes = {
	-- includes utility functions required for following files
	'emulator',
	'tables',
	'colors',
	'utility',
	'shaders',

	-- object hooks
	'hooks/button_callbacks',
	'hooks/uielement',
	'hooks/game',
	'hooks/card',
	'hooks/cardarea',
	'hooks/blind',
	'hooks/common_events',
	'hooks/state_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first
	'ui',
	'poker_hands',
	'items',
	'tarot_reskins',
	'blind_reskins',
	'vanilla_tweaks',

	--- might require functionality
	-- 'options/achievements',
	-- 'options/blinds',

	-- cosmetic
	'queer',
}

for _, module in ipairs(includes) do
	local init, error = NFS.load(SMODS.current_mod.path .. "includes/" .. module ..".lua")
	if error then sendErrorMessage("[Fanworks] Failed to load "..module.." with error "..error) else
		local data = init()
		sendDebugMessage("[Fanworks] Loaded module: " .. module)
	end
end

