local usable_path = SMODS.current_mod.path:match("Mods/[^/]+")
local path_pattern_replace = usable_path:gsub("(%W)","%%%1")
playable_roms = {}

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "fnwk_icon.png",
	px = 32,
	py = 32
})

SMODS.current_mod.config_tab = function()
	local ordered_config = {
		'enable_Jokers',
		'enable_Stands',
		'enable_Consumables',
		'enable_Decks',
		'enable_Tags',
		'enable_Vouchers',
		'enable_Blinds',
		'enable_Challenges',
		'enable_Queer',
		'enable_TarotSkins',
		'enable_VanillaTweaks',
		'enable_BlindReskins',
		--[[
		'enableTrophies',
		--]]
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
				ref_table = fnwk_config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.fnwk_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			right_settings.nodes[#right_settings.nodes + 1] = main_node
			right_count = right_count + 1
			
			if ordered_config[i] == 'enable_Jokers' and fnwk_config['enable_Jokers'] then
				local art_node = create_toggle({
					label = localize("fnwk_options_enableAltArt"),
					w = 1, 
					ref_table = fnwk_config,
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
				ref_table = fnwk_config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.fnwk_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			left_settings.nodes[#left_settings.nodes + 1]  = main_node
			left_count = left_count + 1

			if ordered_config[i] == 'enableJokers' and fnwk_config['enableJokers'] then
				local art_node = create_toggle({
					label = localize("fnwk_options_enable_AltArt"),
					w = 1,
					ref_table = fnwk_config,
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
			fnwk_config_ui
		}
	}
end

local header_scale = 1.1
local bonus_padding = 1.15
local support_padding = 0.015
local artist_size = 0.35
local special_thanks_mod = 0.85
local special_thanks_padding = 0
local artist_padding = 0.03
local coding_scale = 0.90
local shader_scale = 0.9
local text_scale = 0.98

local current_mod = SMODS.current_mod
current_mod.credits_tab = function()
	chosen = true
	return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
		{n = G.UIT.C, config = { align = "tm", padding = 0.2 }, nodes = {
			{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={text = localize("b_credits"), scale = text_scale*1.2, colour = G.C.GREEN, shadow = true}},
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0.05,outline_colour = G.C.GREEN, r = 0.1, outline = 1}, nodes= {
				{n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.R, config={align = "cm", padding = 0.1, minh = 6.2, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
								{n=G.UIT.T, config={text = localize('fnwk_credits_direct'), scale = header_scale * 0.6, colour = G.C.GOLD, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0.1}, nodes={
									{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].gote, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0.1}, nodes={
									{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].vivi, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
						}},
					}},
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{n = G.UIT.C, config = {align = "cm", padding = 0.1 * bonus_padding, minh = 6.140, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes = {
						{n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
							{n = G.UIT.T, config = {text = localize('fnwk_credits_artists'), scale = header_scale * 0.6, colour = HEX('f75294'), shadow = true}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].algebra, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].shaft, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].gote, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].cody, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].cream, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].doopo, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].durandal, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].fizzy, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].gar, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].jester, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].jin, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].leafy, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].mae, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].monky, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].piano, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].pink, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].plus, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].polyg, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].poul, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].mal, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].reda, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].android, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].cejai, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].cringe, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].wario, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].winter, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].torch, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n = G.UIT.R, config = {align = "tm", padding = artist_padding}, nodes = {
									{n = G.UIT.T, config = {text = ArrowAPI.credits[current_mod.id].tos, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
						}},
					} },
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0, r = 0.1, }, nodes = {
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "cm", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('fnwk_credits_coding'), scale = header_scale*0.6, colour = G.C.ORANGE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = 0.05}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].gote, scale = text_scale*0.44*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0.05}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].daed, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0.05}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].keku, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0.05}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].vivi, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
							}},
							{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, vert = true, shadow = true}},
								}},
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0.1, minh = 3.9, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = localize('fnwk_credits_shaders'), scale = header_scale * 0.515, colour = G.C.DARK_EDITION, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "cm", padding = support_padding}, nodes= {
										{n=G.UIT.R, config={align = "tm", padding = 0.05}, nodes={
											{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].vivi, scale = text_scale*0.55*shader_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
										}},
									}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "separator", scale = text_scale*0.3, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1, minh=2}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
								{n=G.UIT.T, config={text = localize('fnwk_credits_thanks'), scale = header_scale*0.55, colour = G.C.GREEN, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "cm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].araki, scale = text_scale*0.45*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "cm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].luckyland, scale = text_scale*0.45*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "cm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = ArrowAPI.credits[current_mod.id].abrams, scale = text_scale*0.45*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
							}},
						}},
					}},
				}},
			}}
		}}
	}}
end

SMODS.current_mod.extra_tabs = function()
	return {
		{
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
		},
		-- insert more tables with the same structure here
	}
end