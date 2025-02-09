
fnwk_config = SMODS.current_mod.config
fnwk_enabled = copy_table(fnwk_config)

SMODS.optional_features.quantum_enhancements = true

local includes = {
	-- includes utility functions required for following files
	'utility',
	'credits',

	-- object hooks
	'hooks/common_events',

	-- option files
	--- jokers are required for some following files so include them first
	'options/jokers',
	'options/stands',
	'options/tarot',
	'options/consumabletweaks',
	'options/consumables',

	--- might require functionality
	'options/achievements',
	'options/bosses',
	'options/challenges',
	'options/decks',

	-- cosmetic
	'options/queer',
	'options/skins',
}


for _, module in ipairs(includes) do
	local init, error = NFS.load(SMODS.current_mod.path .. "includes/" .. module ..".lua")
	if error then sendErrorMessage("[Fanworks] Failed to load "..module.." with error "..error) else
		local data = init()
		sendDebugMessage("[Fanworks] Loaded module: " .. module)
	end
end

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "fnwk_icon.png",
	px = 32,
	py = 32
}):register()

function G.FUNCS.fnwk_restart()

	local settingsMatch = true
	for k, v in pairs(fnwk_enabled) do
		if v ~= fnwk_config[k] then
			settingsMatch = false
		end
	end
	
	if settingsMatch then
		sendDebugMessage('Settings match')
		SMODS.full_restart = 0
	else
		sendDebugMessage('Settings mismatch, restart required')
		SMODS.full_restart = 1
	end
end

SMODS.current_mod.config_tab = function()
	local ordered_config = {
		'enableJokers',
		'enableQueer',
		'enableTarotSkins',
		'enableConsumableTweaks',
		--[[
		'enableTrophies',
		'enableConsumables',
		'enableStands',
		'enableBosses',
		'enableDecks',
		'enableSkins',
		'enableChallenges',
		--]]
	}
	local left_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	for i, k in ipairs(ordered_config) do
		if #right_settings.nodes < #left_settings.nodes then
			right_settings.nodes[#right_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = fnwk_config, ref_value = ordered_config[i], callback = G.FUNCS.fnwk_restart})
		else
			left_settings.nodes[#left_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = fnwk_config, ref_value = ordered_config[i], callback = G.FUNCS.fnwk_restart})
		end
	end
	local fnwk_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.05,
			colour = G.C.BLACK,
		},
		nodes = {
			fnwk_config_ui
		}
	}
end
