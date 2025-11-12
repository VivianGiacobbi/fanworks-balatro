local usable_path = JoJoFanworks.path:match("Mods/[^/]+")
local path_pattern_replace = usable_path:gsub("(%W)","%%%1")
playable_roms = {}

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "fnwk_icon.png",
	px = 32,
	py = 32
})

if JoJoFanworks.current_config['enable_Title'] then
	-- Title Screen Replacements
	SMODS.Atlas {
		key = 'balatro',
		path = 'fnwk_title.png',
		px = 591,
		py = 216,
		prefix_config = { key = false }
	}

	SMODS.Atlas {
		key = 'title_sub',
		path = 'fnwk_title_sub.png',
		px = 591,
		py = 216,
	}
end





---------------------------
--------------------------- Garc Quotes
---------------------------

JoJoFanworks.quip_filter = function(quip, quip_type)
	local mod = quip.original_mod
    return (next(SMODS.find_card('j_fnwk_fanworks_jogarc', true)) and mod and mod.id == 'fanworks') or (not mod or mod.id ~= 'fanworks')
end

for i=1, 12 do
	SMODS.JimboQuip({
		key = 'gwq_'..i,
		type = 'win',
		extra = {center = 'j_fnwk_fanworks_jogarc'},
	})
end

for i=1, 16 do
	SMODS.JimboQuip({
		key = 'glq_'..i,
		type = 'loss',
		extra = {center = 'j_fnwk_fanworks_jogarc'},
	})
end

---------------------------
--------------------------- Title Screen Easter eggs
---------------------------

JoJoFanworks.config_tab = function()
	local ordered_config = {
		'enable_Jokers',
		'enable_Stands',
		'enable_Consumables',
		'enable_Decks',
		CardSleeves and 'enable_Sleeves' or nil,
		'enable_Tags',
		'enable_Vouchers',
		'enable_Blinds',
		'enable_Challenges',
		'enable_Queer',
		'enable_TarotSkins',
		'enable_BlindReskins',
		'enable_Title',
		'enable_Achievements',
	}
	local left_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local left_count = 0
	local right_count = 0

	for i, k in ipairs(ordered_config) do
		if right_count < left_count then
			local main_node = create_toggle({
				label = localize("fnwk_options_"..ordered_config[i]),
				w = 1,
				ref_table = JoJoFanworks.config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.fnwk_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			right_settings.nodes[#right_settings.nodes + 1] = main_node
			right_count = right_count + 1

			if ordered_config[i] == 'enable_Jokers' and JoJoFanworks.config['enable_Jokers'] then
				local art_node = create_toggle({
					label = localize("fnwk_options_enableAltArt"),
					w = 1,
					ref_table = JoJoFanworks.config,
					ref_value = 'enableAltArt',
					callback = G.FUNCS.fnwk_apply_alts
				})
				art_node.config.align = 'tr'
				right_settings.nodes[#right_settings.nodes + 1] = art_node
				right_count = right_count + 1

				right_settings.nodes[#right_settings.nodes + 1] = { n = G.UIT.R, config = { h = 1, align = "tr", padding = 0.25 } }
			end
		else
			local main_node = create_toggle({
				label = localize("fnwk_options_"..ordered_config[i]),
				w = 1,
				ref_table = JoJoFanworks.config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.fnwk_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			left_settings.nodes[#left_settings.nodes + 1]  = main_node
			left_count = left_count + 1

			if ordered_config[i] == 'enableJokers' and JoJoFanworks.config['enableJokers'] then
				local art_node = create_toggle({
					label = localize("fnwk_options_enable_AltArt"),
					w = 1,
					ref_table = JoJoFanworks.config,
					ref_value = 'enableAltArt',
					callback = G.FUNCS.fnwk_apply_alts
				})
				art_node.config.align = 'tr'
				left_settings.nodes[#left_settings.nodes + 1] = art_node
				left_count = left_count + 1

				left_settings.nodes[#left_settings.nodes + 1] = { n = G.UIT.R, config = { h = 1, align = "tr", padding = 0.25 } }
			end
		end
	end

	local fnwk_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0.25 }, nodes = { left_settings, right_settings } }
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
			fnwk_config_ui,
			{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 3, maxw = 5 }, nodes={
				{n=G.UIT.R, config={align = "cm", minh = 0.6, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = "fnwk_reset_achievements", shadow = true, focus_args = {nav = 'wide'}}, nodes={
					{n=G.UIT.T, config={text = localize("fnwk_options_reset_achievements"), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}}
				}},
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.T, config={id = 'warn', text = localize('ph_click_confirm'), scale = 0.4, colour = G.C.CLEAR}}
			}}
		}
	}
end

JoJoFanworks.extra_tabs = function()
	return {
		#love.filesystem.getDirectoryItems(usable_path .. "/includes/LuaNES/roms/") > 0 and {
			label = 'Cabinet Man',
			tab_definition_function = function()
				-- works in the same way as mod.config_tab
				local button_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }

				playable_roms = {}
				local count = 0
				for s in ArrowAPI.loading.recursive_file_enumerate(usable_path .. "/includes/LuaNES/roms/"):gmatch("[^\r\n]+") do
					if ArrowAPI.string.contains(s, '.nes') then
						local name = string.gsub(s, path_pattern_replace .. "/includes/LuaNES/roms//", "")
						name = string.gsub(name, '.nes', '')
						playable_roms[name] = true
						count = count + 1
					end
				end

				if count > 0 then
					for k, _ in pairs(playable_roms) do
						local name = k
						local main_node = UIBox_button({
							label = {name},
							button = 'fnwk_start_rom',
							minw = 5,
							maxw = 5,
							choice = name
						})

						main_node.config.align = 'tr'
						main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
						button_settings.nodes[#button_settings.nodes + 1] = main_node
						button_settings.nodes[#button_settings.nodes + 1] = { n = G.UIT.R, config = { h = 1, align = "tr", padding = 0.25 } }
					end
				end

				local cabinet_ui = { n = G.UIT.C, config = { align = "tm", padding = 0.25 }, nodes = { button_settings } }
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
						cabinet_ui
					}
				}
			end,
		} or nil,
		-- insert more tables with the same structure here
	}
end