local items_to_load = {
	Joker = {
		-- fanworks
		'fanworks_jogarc',
		'fanworks_tos',
		'fanworks_jester',
		'fanworks_mascot',
		'fanworks_fanworks',
		'fanworks_standoff',

		-- jojopolis
		'jojopolis_jokestar',
		'jojopolis_high',

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
		'crimson_bloodletting',
			
		-- gotequest
		'gotequest_pair',
		'gotequest_killing',
		'gotequest_headlong',
		'gotequest_2hot',
		'gotequest_ajorekesr',
		'gotequest_will',
		'gotequest_lambiekins',

		-- culture shock
		'culture_adaptable',

		-- glass lariats
		'glass_jokestar',

		-- planck's creek
		'plancks_jokestar',
		'plancks_unsure',
		'plancks_skeptic',
		'plancks_ghost',

		-- last hope army
		'last_morse',

		-- rockhard in a funky place
		'rockhard_rebirth',
		-- 'rockhard_peppers',
		'rockhard_nameless',
		'rockhard_alfie',
		'rockhard_vasos',
		'rockhard_trans',
		'rockhard_numbers',

		-- iron touch
		'iron_sanctuary',
		'iron_boney',

		-- lighted stage
		'lighted_ge',
		'lighted_square',

		-- jojomania
		'mania_jokestar',
		'mania_fragile',

		-- spirit lines
		'spirit_halves',
		-- 'spirit_aquarium',
		'spirit_gambler',
		'spirit_corpse',
		'spirit_rotten',

		-- industry baby
		'industry_loyal',

		-- double down
		'double_clark',
		'double_firewalker',
		'double_devastation',

		-- careless cargo
		'careless_jokestar',

		-- stalk forest club
		'stalk_jokestar',

		-- rubicon crossroads
		'rubicon_fishy',
		'rubicon_infidel',
		'rubicon_thnks',
		'rubicon_moonglass',
		'rubicon_crown',

		-- streetlight pursuit
		'streetlight_fledgling',
		'streetlight_resil',
		'streetlight_indulgent',
		'streetlight_methodical',
		'streetlight_industrious',
		'streetlight_arrow',
		'streetlight_pinstripe',
		'streetlight_biased',
		'streetlight_teenage',
		'streetlight_cabinet',

		-- whiplash riot
		'whiplash_quiet',

		-- bluebolt incarnation
		'bluebolt_jokestar',
		'bluebolt_secluded',
		'bluebolt_impaired',
		'bluebolt_sexy',
		'bluebolt_tuned',
		

		-- sunshine deluxe
		'sunshine_duo',
		'sunshine_laconic',
		'sunshine_funkadelic',
		'sunshine_reliable',

		-- no man's army
		'noman_unknown',

		-- scepter files
		'scepter_card',

		-- yo yo ma
		'yym_sheet',

		-- golden generation
		'golden_generation',

		-- cold iron streets,
		'cis_jokestar',

		--love once buried
		'love_jokestar',
		'love_holy',

		-- my digital venus
		'mdv_shock',

		-- jojojidai
		'jojojidai_soldiers',

		-- lipstick_vogue
		'lipstick_ego',

		-- jojospectacle,
		'jspec_energetic',
		'jspec_seal',
		'jspec_joepie',
		'jspec_kunst',
		'jspec_ilsa',
		
		-- shit realm
		'fanworks_bathroom',
	},

	Consumable = {
		'spec_impulse',
		'spec_ichor',
		'spec_mood'
	},

	Stand = {
		-- bone to blades
		'bone_king',
		'bone_king_farewell',

		-- city living
		'city_dead',
		'city_opera',

		-- crimson jungle
		'crimson_fortunate',

		-- gotequest
		'gotequest_born',
		'gotequest_sweet',
		'gotequest_takyon',

		--glass lariats
		'glass_big',

		-- rockhard in a funky place
		'rockhard_peppers',
		'rockhard_quadro',

		-- the lighted stage
		'lighted_limelight',
		'lighted_money',

		-- jojomania
		'mania_moving',

		-- spirit lines
		'spirit_achtung',
		'spirit_achtung_stranger',
		'spirit_sweet',
		'spirit_ultimate',

		-- double down
		'double_wine',

		-- rubicon crossroads
		'rubicon_dance',

		-- streetlight pursuit
		'streetlight_paperback',
		'streetlight_paperback_rewrite',
		'streetlight_notorious',

		-- whiplash riot
		'whiplash_never',

		-- bluebolt incarnation
		'bluebolt_thunder',
		'bluebolt_thunder_dc',
		'bluebolt_chemical',
		
		-- sunshine deluxe
		'sunshine_electric',
		'sunshine_damned',
		'sunshine_downward',
		'sunshine_red',

		-- scepter files
		'scepter_lenfer',

		-- JJ29: Stardust Rebels
		'rebels_rebel'

	},
	
	Deck = {
		'fanworks_deck',
		'act',
	},

	Sleeve = {
		'sleeve_fanworks_deck'
	},

	Voucher = {
		'rubicon_kitty',
    	'rubicon_parade',
		'streetlight_waystone',
		'streetlight_binding',
		'sunshine_rapture',
		'sunshine_totality'
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
	if next(items_to_load[k]) and fnwk_filter_loading(k) then
		for i = 1, #v do
			FnwkLoadItem(v[i], k)
		end
	end
end