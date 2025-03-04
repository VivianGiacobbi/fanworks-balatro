local jokersToLoad = {
    --[[
    'tetris',
    --]]

    -- streetlight pursuit
	'streetlight_fledgling',
    'streetlight_resil',
	'streetlight_indulgent',
	'streetlight_methodical',
	'streetlight_industrious',
    'streetlight_pinstripe',
	'streetlight_cabinet',
    -- spirit lines
    -- 'spirit_aquarium',
    -- bluebolt incarnation
    'bluebolt_jokestar',
	'bluebolt_sexy',
    'bluebolt_secluded',
	'bluebolt_tuned',
    -- planck's creek
    'plancks_jokestar',
    'plancks_unsure',
    'plancks_skeptic',
    'plancks_crazy',
    -- moscow calling
    'moscow_mule',
    -- sunshine deluxe
	'sunshine_duo',
    'sunshine_laconic',
    'sunshine_funkadelic',
    'sunshine_reliable',
    -- rockhard in a funky place
    'rockhard_rebirth',
    -- 'rockhard_peppers',
    'rockhard_trans',
	'rockhard_nameless',
	'rockhard_alfie',
	'rockhard_numbers',
	-- rubicon crossroads
	'rubicon_infidel',
	'rubicon_film',
	'rubicon_moonglass',
	'rubicon_bone',

	-- jojopolis
	'jojopolis_jokestar',
	--gotequest
	'gotequest_lambiekins',
	--spirit lines
	'spirit_halves',
	--doubledown
	'double_clark',
	--love once buried
	'love_jokestar',
	-- lighted state
	'lighted_square',
	-- iron touch
	'iron_boney',
	-- jojospectacle,
	'jspec_joepie',
	'jspec_kunst',
	'jspec_ilsa',
	-- fanworks
	'fanworks_tos',
	'fanworks_jester',
	-- scepter files
	'scepter_card',
	-- crimson jungle
	'crimson_golden',
}

local alt_jokers = {
    ['love_jokestar'] = true,
    ['plancks_crazy'] = true,
	['plancks_jokestar'] = true,
    ['plancks_skeptic'] = true,
    ['plancks_unsure'] = true,
    ['rockhard_alfie'] = true,
    ['rockhard_nameless'] = true,
    ['rockhard_numbers'] = true,
    ['rockhard_rebirth'] = true,
    ['streetlight_fledgling'] = true,
    ['streetlight_indulgent'] = true,
    ['streetlight_industrious'] = true,
    ['streetlight_methodical'] = true,
    ['streetlight_resil'] = true
}

if not fnwk_enabled['enableJokers'] then
	return
end

for i, v in ipairs(jokersToLoad) do
	local jokerInfo = assert(SMODS.load_file("jokers/" .. v .. ".lua"))()
	jokerInfo.key = v
	jokerInfo.atlas = v
	local atlasKey = v
	if jokerInfo.texture then
		atlasKey = jokerInfo.texture
		jokerInfo.atlas = jokerInfo.texture
	end
	jokerInfo.pos = { x = 0, y = 0 }
	if jokerInfo.hasSoul then
		jokerInfo.pos = { x = 1, y = 0 }
		jokerInfo.soul_pos = { x = 2, y = 0 }
	end

	if jokerInfo.fanwork then
		jokerInfo.no_mod_badges = true
		jokerInfo.set_badges = function(self, card, badges)
			local title = localize('ba_'..jokerInfo.fanwork)
			local color = HEX(localize('co_'..jokerInfo.fanwork))
			local text = G.localization.misc.dictionary['te_'..jokerInfo.fanwork] and HEX(localize('te_'..jokerInfo.fanwork)) or G.C.WHITE
			badges[#badges+1] = create_badge(title, color, text, 1)
		end
	end

	local joker = SMODS.Joker(jokerInfo)
	for k_, v_ in pairs(joker) do
		if type(v_) == 'function' then
			joker[k_] = jokerInfo[k_]
		end
	end

	SMODS.Atlas({ key = atlasKey, path = "jokers/" .. atlasKey .. ".png", px = jokerInfo.width or 71, py = jokerInfo.height or  95 })
	if alt_jokers[v] then
		SMODS.Atlas({ key = atlasKey..'_alt', path = "jokers/" .. atlasKey .. '_alt'.. ".png", px = 71, py = 95 })
	end

end


function G.FUNCS.fnwk_apply_alts()
	fnwk_enabled = copy_table(fnwk_config)
    for k, v in pairs(alt_jokers) do
		G.P_CENTERS['j_fnwk_'..k].atlas = 'fnwk_'..k..(fnwk_enabled['enableAltArt'] and '_alt' or '')
    end
end