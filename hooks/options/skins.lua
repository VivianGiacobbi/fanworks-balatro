--[[
local skin_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/skins/"):gmatch("[^\r\n]+") do
	skin_files[#skin_files + 1] = s:gsub(path_pattern_replace .. "/assets/1x/skins/", "")
end

local deck_skins = {}
for _, file in ipairs(skin_files) do
	deck_skins[#deck_skins + 1] = file:sub(2, -5)
end

local collab_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/collabs/"):gmatch("[^\r\n]+") do
	if s:match("%.png$") then
		collab_files[#collab_files + 1] = s:gsub(path_pattern_replace .. "/assets/1x/collabs/", "")
	end
end

local collab_skins = {}
for _, file in ipairs(collab_files) do
	collab_skins[#collab_skins + 1] = file:sub(2, -5)
end

if fnwk_enabled['enableSkins'] then
    if fnwk_enabled['enableSkins'] then
	for suit, color in pairs(G.C.SUITS) do
		local c
		if suit == "Hearts" then c = HEX("e14e62")
		elseif suit == "Diamonds" then c = HEX("3c56a4")
		elseif suit == "Clubs" then c = HEX("4dac84")
		elseif suit == "Spades" then c = HEX("8d619a")
		end
		SMODS.Suits[suit].keep_base_colours = false
		SMODS.Suits[suit].lc_colour = c
		SMODS.Suits[suit].hc_colour = c
		if G.VANILLA_COLLABS then
			G.VANILLA_COLLABS.lc_colours[suit] = c
			G.VANILLA_COLLABS.hc_colours[suit] = c
		end
		G.C.SO_1[suit] = c
		G.C.SO_2[suit] = c
	end

	-- Base Deck Textures
	for i = 1, 2 do
		SMODS.Atlas {
			key = "cards_"..i,
			path = "BaseDeck.png",
			px = 71,
			py = 95,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_"..i,
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_",
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
	end

	SMODS.Joker:take_ownership('greedy_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('lusty_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('wrathful_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('gluttenous_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)

	SMODS.Joker:take_ownership('onyx_agate', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('rough_gem', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)

	-- Skin Atlases
	for _, skin in ipairs(deck_skins) do
		SMODS.Atlas{
			key = skin,
			path = "skins/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS"
		}
	end

	-- Collab Atlases
	for _, skin in ipairs(collab_skins) do
		SMODS.Atlas{
			key = skin,
			path = "collabs/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS",
		}
	end

	-- Characters Replacements
	SMODS.DeckSkin:take_ownership('collab_AU',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_h_characters",
		hc_atlas = "fnwk_h_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_TW',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_s_characters",
		hc_atlas = "fnwk_s_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_VS',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_c_characters",
		hc_atlas = "fnwk_c_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_DTD',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_d_characters",
		hc_atlas = "fnwk_d_characters"
	})

	-- The Mascots, Classics, Wildcards, and Confidants
	SMODS.DeckSkin:take_ownership('collab_TBoI',{
		loc_txt = {
			["en-us"] = "The Wildcards"
		},
		lc_atlas = "fnwk_h_wildcards",
		hc_atlas = "fnwk_h_wildcards"
	})
	SMODS.DeckSkin:take_ownership('collab_CYP',{
		loc_txt = {
			["en-us"] = "The Confidants"
		},
		lc_atlas = "fnwk_s_confidants",
		hc_atlas = "fnwk_s_confidants"
	})
	SMODS.DeckSkin:take_ownership('collab_STS',{
		loc_txt = {
			["en-us"] = "The Mascots"
		},
		lc_atlas = "fnwk_c_mascots",
		hc_atlas = "fnwk_c_mascots"
	})
	SMODS.DeckSkin:take_ownership('collab_SV',{
		loc_txt = {
			["en-us"] = "The Classics"
		},
		lc_atlas = "fnwk_d_classics",
		hc_atlas = "fnwk_d_classics"
	})

	-- Vineshroom
	SMODS.DeckSkin:take_ownership('collab_PC',{
		ranks =  {"Ace"},
		loc_txt = {
			["en-us"] = "Vineshroom"
		},
		lc_atlas = "c_vineshroom",
		hc_atlas = "c_vineshroom"
	})

	-- Deck Skins: Clubs
	SMODS.DeckSkin:take_ownership('collab_WF',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_characters_VS",
		hc_atlas = "c_characters_VS",
		loc_txt = {
			["en-us"] = "Characters [VS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_mascots_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_mascots_VS",
		hc_atlas = "c_mascots_VS",
		loc_txt = {
			["en-us"] = "The Mascots [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_VS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_DS",
		hc_atlas = "c_collab_VS_DS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_DS",
		loc_txt = {
			["en-us"] = "Slay The Spire [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_PC_DS",
		loc_txt = {
			["en-us"] = "Potion Craft [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_WF_DS",
		loc_txt = {
			["en-us"] = "Warframe [DS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_VS",
		loc_txt = {
			["en-us"] = "Slay The Spire [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC_VS",
		loc_txt = {
			["en-us"] = "Potion Craft [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF_VS",
		loc_txt = {
			["en-us"] = "Warframe [VS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS",
		loc_txt = {
			["en-us"] = "Slay The Spire"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC",
		loc_txt = {
			["en-us"] = "Potion Craft"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF",
		loc_txt = {
			["en-us"] = "Warframe"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_shroomless",
		suit = "Clubs",
		ranks =  {"Ace"},
		lc_atlas = "c_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Hearts
	SMODS.DeckSkin:take_ownership('collab_CL',{
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_poops",
		hc_atlas = "h_poops",
		loc_txt = {
			["en-us"] = "The Poops"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_D2',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU_ES",
		hc_atlas = "h_collab_AU_ES",
		loc_txt = {
			["en-us"] = "Among Us [ES]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_h_collab_TBoI_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_TBoI_ES",
		hc_atlas = "h_collab_TBoI_ES",
		loc_txt = {
			["en-us"] = "The Binding of Isaac [ES]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_CL_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_CL_ES",
		loc_txt = {
			["en-us"] = "Cult of the Lamb [ES]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_D2_ES",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2 [ES]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_collab_AU",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU",
		loc_txt = {
			["en-us"] = "Among Us"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_TBoI",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_TBoI",
		loc_txt = {
			["en-us"] = "The Binding of Isaac"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_CL",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_CL",
		loc_txt = {
			["en-us"] = "Cult of the Lamb"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_D2",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_shroomless",
		suit = "Hearts",
		ranks =  {"Ace"},
		lc_atlas = "h_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Spades
	SMODS.DeckSkin:take_ownership('collab_SK',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW_TC",
		hc_atlas = "s_collab_TW_TC",
		loc_txt = {
			["en-us"] = "The Witcher [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_DS',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP_TC",
		hc_atlas = "s_collab_CYP_TC",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077 [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_s_collab_SK_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_SK_TC",
		loc_txt = {
			["en-us"] = "Shovel Knight [TC]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_DS_TC",
		loc_txt = {
			["en-us"] = "Don't Starve [TC]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_collab_TW",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW",
		loc_txt = {
			["en-us"] = "The Witcher"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_CYP",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_SK",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_SK",
		loc_txt = {
			["en-us"] = "Shovel Knight"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_DS",
		loc_txt = {
			["en-us"] = "Don't Starve"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_shroomless",
		suit = "Spades",
		ranks =  {"Ace"},
		lc_atlas = "s_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Diamonds
	SMODS.DeckSkin:take_ownership('collab_EG',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD_FS",
		hc_atlas = "d_collab_DTD_FS",
		loc_txt = {
			["en-us"] = "Dave The Diver [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_XR',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV_FS",
		hc_atlas = "d_collab_SV_FS",
		loc_txt = {
			["en-us"] = "Stardew Valley [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_d_collab_EG_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_EG_FS",
		loc_txt = {
			["en-us"] = "Enter the Gungeon [FS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_XR_FS",
		loc_txt = {
			["en-us"] = "1000xRESIST [FS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_collab_DTD",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD",
		loc_txt = {
			["en-us"] = "Dave The Diver"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_SV",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV",
		loc_txt = {
			["en-us"] = "Stardew Valley"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_EG",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_EG",
		loc_txt = {
			["en-us"] = "Enter the Gungeon"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_XR",
		loc_txt = {
			["en-us"] = "1000xRESIST"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_shroomless",
		suit = "Diamonds",
		ranks =  {"Ace"},
		lc_atlas = "d_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}
    end

    
    --[[
    SMODS.Atlas{
        key = 'alt_color_jokers',
        path = "colorjokers.png",
        px = 71,
        py = 95,
        atlas_table = "ASSET_ATLAS",
    }

    if AltTexture and TexturePack then
        AltTexture({
            key = 'jokers',
            set = 'Joker',
            path = 'colorjokers.png',
            loc_txt = {
                name = 'Jokers'
            },
            keys = {
                'j_gluttenous_joker',
                'j_greedy_joker',
                'j_lusty_joker',
                'j_wrathful_joker',
                'j_onyx_agate',
                'j_rough_gem'
            },
            original_sheet = true
        })

        TexturePack{
            key = 'fnwk',
            textures = {
                'fnwk_jokers',
                'fnwk_tarot',
            },
            loc_txt = {
                name = 'Cardsauce Malverk Compatibility',
                text = {
                    "Enables the Cardsauce reskins of the Suit Color",
                    "Jokers + 2 Tarot cards to work with Malverk!",
                }
            }
        }
    end
--]]