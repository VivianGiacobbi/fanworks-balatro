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
    -- spirit lines
    -- 'spirit_aquarium',
    -- bluebolt incarnation
    'bluebolt_jokestar',
    'bluebolt_secluded',
    -- planck's creek
    'plancks_jokestar',
    'plancks_unsure',
    'plancks_skeptic',
    'plancks_crazy',
    -- moscow calling
    'moscow_mule',
    -- sunshine deluxe
    'sunshine_laconic',
    'sunshine_funkadelic',
    'sunshine_reliable',
    -- rockhard in a funky place
    'rockhard_rebirth',
    'rockhard_peppers',
    'rockhard_trans',
	-- rubicon crossroads
	'rubicon_bone',
	'rubicon_moonglass',
	'rubicon_infidel',
	-- jojopolis
	'jojopolis_jordan',
	--gotequest
	'gq_lambiekins',
	--doubledown
	'dd_clark',
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
			badges[#badges+1] = create_badge(localize('ba_'..jokerInfo.fanwork), HEX(localize('co_'..jokerInfo.fanwork)), G.C.WHITE, 1)
		end
	end

	local joker = SMODS.Joker(jokerInfo)
	for k_, v_ in pairs(joker) do
		if type(v_) == 'function' then
			joker[k_] = jokerInfo[k_]
		end
	end

	SMODS.Atlas({ key = atlasKey, path ="jokers/" .. atlasKey .. ".png", px = jokerInfo.width or 71, py = jokerInfo.height or  95 })
end