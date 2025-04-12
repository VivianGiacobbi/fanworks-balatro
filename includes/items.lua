local items_to_load = {
	Joker = {
		-- fanworks
		'fanworks_tos',
		'fanworks_jester',
		-- 'fanworks_mascot',

		-- jojopolis
		'jojopolis_jokestar',

		-- a$ap mob feedback
		'asap_jokestar',

		-- bone to blades
		'bone_samurai',
		'bone_destroyer',

		-- city living
		'city_neet',

		-- moscow calling
		'moscow_mule',

		-- crimson jungle
		'crimson_golden',
			
		-- gotequest
		'gotequest_killing',
		'gotequest_headlong',

		-- culture shock
		'culture_adaptable',

		-- glass lariats
		'glass_jokestar',

		-- planck's creek
		'plancks_unsure',
		'plancks_ghost',

		-- last hope army

		-- rockhard in a funky place
		'rockhard_rebirth',
		'rockhard_nameless',
		'rockhard_numbers',

		-- iron touch
		'iron_boney',

		-- lighted stage
		'lighted_ge',

		-- jojomania

		-- spirit lines
		'spirit_halves',
		'spirit_corpse',

		-- industry baby

		-- double down
		'double_clark',
		'double_devastation',

		-- careless cargo

		-- stalk forest club
		-- rubicon crossroads
		'rubicon_fishy',
		'rubicon_thnks',
		'rubicon_crown',
		'rubicon_moonglass',

		-- streetlight pursuit
		'streetlight_fledgling',
		'streetlight_resil',
		'streetlight_indulgent',
		'streetlight_methodical',

		-- whiplash riot

		-- bluebolt incarnation
		'bluebolt_jokestar',
		'bluebolt_sexy',
		'bluebolt_tuned',
		'bluebolt_secluded',

		-- sunshine deluxe
		'sunshine_duo',
		'sunshine_laconic',
		'sunshine_funkadelic',

		-- no man's army

		-- scepter files

		-- yo yo ma
		'yym_sheet',

		-- golden generation
		'golden_generation',

		-- cold iron streets

		--love once buried
		'love_jokestar',

		-- my digital venus
		-- jojojidai
		'jojojidai_soldiers',

		-- lipstick_vogue
		'lipstick_ego',

		-- jojospectacle
		'jspec_joepie',
	},

	Consumable = {
		'spec_stone',
		'spec_impulse',
		'spec_ichor',
		'spec_mood'
	},
	
	Deck = {
		'fanworks',
	},

	Voucher = {
		'rubicon_kitty',
    	'rubicon_parade'
	},

	Challenge = {
		'beyondcanon',
	},

	Blind = {
		--'hog',
		--'tray',
		--'vod',
		--'finger',
		--'mochamike',
	},
}

for k, v in pairs(items_to_load) do
	if next(items_to_load[k]) and fnwk_enabled['enable'..k..'s'] then
		for i = 1, #v do
			FnwkLoadItem(v[i], k, false)
		end
	end
end