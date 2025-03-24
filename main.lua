
fnwk_config = SMODS.current_mod.config
fnwk_enabled = copy_table(fnwk_config)

SMODS.optional_features.quantum_enhancements = true
SMODS.optional_features.cardareas.unscored = true

G.C.FANWORKS = HEX('DD85B4')

local includes = {
	-- includes utility functions required for following files
	'tables',
	'utility',
	'shaders',

	-- object hooks
	'hooks/game',
	'hooks/card',
	'hooks/common_events',
	'hooks/state_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first
	'ui',
	'items',
	'tarot_reskins',
	'consumable_tweaks',

	--- might require functionality
	-- 'options/achievements',
	-- 'options/blinds',
	-- 'options/challenges',

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

