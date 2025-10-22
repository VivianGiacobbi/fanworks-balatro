SMODS.Atlas({ key = 'achievements', path = "achievements.png", px = 66, py = 66})

SMODS.ObjectType {
    default = 'j_fnwk_bluebolt_sexy',
    key = 'fnwk_women',
	cards = {
		['j_lusty_joker'] = true,
        ['j_blueprint'] = true,
        ['j_brainstorm'] = true,
        ['j_shoot_the_moon'] = true,
        ['j_fnwk_rubicon_moonglass'] = true,
        ['j_fnwk_streetlight_fledgling'] = true,
        ['j_fnwk_streetlight_indulgent'] = true,
        ['j_fnwk_streetlight_industrious'] = true,
        ['j_fnwk_streetlight_methodical'] = true,
        ['j_fnwk_rubicon_thnks'] = true,
        ['j_fnwk_streetlight_resil'] = true,
        ['j_fnwk_bone_destroyer'] = true,
        ['j_fnwk_mania_jokestar'] = true,
        ['j_fnwk_gotequest_killing'] = true,
        ['j_fnwk_bluebolt_tuned'] = true,
        ['j_fnwk_love_holy'] = true,
        ['j_drivers_license'] = true,
        ['j_fnwk_rockhard_rebirth'] = true,
        ['j_fnwk_bluebolt_sexy'] = true,
        ['j_fnwk_bluebolt_secluded'] = true,
        ['j_fnwk_glass_jokestar'] = true,
        ['j_fnwk_love_jokestar'] = true,
	}
}

SMODS.ConsumableType {
    default = 'c_fnwk_spec_mood',
    key = 'fnwk_stand_world',
	shop_rate = 0,
	primary_colour = G.C.SECONDARY_SET.Spectral,
	secondary_colour = G.C.SECONDARY_SET.Spectral,
	no_collection = true,
	no_doe = true,
	cards = {
		['c_jojobal_spec_mask'] = not not next(SMODS.find_mod('jojobal')),
		['c_fnwk_spec_impulse'] = true,
		['c_fnwk_spec_mood'] = true,
	}
}

ArrowAPI.loading.batch_load({
	Joker = {
		items = {
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
			'gotequest_will',
			'gotequest_lambiekins',

			-- culture shock
			'culture_adaptable',

			-- glass lariats
			'glass_jokestar',

			-- last hope army
			'last_morse',

			-- rockhard in a funky place
			'rockhard_rebirth',
			'rockhard_nameless',
			'rockhard_alfie',
			'rockhard_vasos',
			'rockhard_trans',
			'rockhard_numbers',

			-- iron touch
			'iron_sanctuary',
			'iron_boney',

			-- lighted stage
			'lighted_stolen',
			'lighted_square',

			-- jojomania
			'mania_jokestar',

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

			-- my digital venus
			'mdv_surface',
			'mdv_shock',

			-- no man's army
			'noman_unknown',

			-- yo yo ma
			'yym_sheet',

			-- golden generation
			'golden_generation',

			-- cold iron streets,
			'cis_jokestar',

			-- jj29: stardust rebels
			'rebels_drowning',

			-- love once buried
			'love_jokestar',
			'love_holy',

			'redrising_oblivious',

			-- jojojidai
			'jojojidai_soldiers',

			-- lipstick_vogue
			'lipstick_bronx',

			-- dark things
			'dark_foxglove',

			-- jojospectacle,
			'jspec_sharp',
			'jspec_seal',
			'jspec_joepie',
			'jspec_kunst',
			'jspec_ilsa',

			-- shit realm
			'fanworks_bathroom',

			-- dummy
			'banned_jokers',
			'banned_commons'
		}
	},

	Consumable = {
		items = {
			'spec_impulse',
			'spec_mood'
		}
	},

	Stand = {
		items = {
			-- jojopolis
			'jojopolis_hgm',
			'jojopolis_hgm_cosmic',

			-- bone to blades
			'bone_king',
			'bone_king_farewell',

			-- city living
			'city_dead',
			'city_opera',

			-- crimson jungle
			'crimson_fortunate',
			'crimson_cough',

			-- gotequest
			'gotequest_takyon',
			'gotequest_born',
			'gotequest_sweet',


			'culture_starboy',

			-- glass lariats
			'glass_big',

			-- last hope army
			'last_tragic',
			'last_saturn',

			-- rockhard in a funky place
			'rockhard_peppers',
			'rockhard_quadro',
			'rockhard_misirlou',

			-- iron touch
			'iron_shatter',

			-- the lighted stage
			'lighted_limelight',
			'lighted_money',

			-- rubicon crossroads
			'rubicon_infidelity',
			'rubicon_dance',
			'rubicon_mother',

			-- streetlight pursuit
			'streetlight_disturbia',
			'streetlight_neon',
			'streetlight_neon_favorite',
			'streetlight_eurythmics',
			'streetlight_rockin',
			'streetlight_paperback',
			'streetlight_paperback_rewrite',
			'streetlight_notorious',

			-- bluebolt incarnation
			'bluebolt_thunder',
			'bluebolt_thunder_dc',
			'bluebolt_chemical',
			'bluebolt_insane',

			-- sunshine deluxe
			'sunshine_electric',
			'sunshine_damned',

			-- JJ29: Stardust Rebels
			'rebels_rebel',

			-- love once buried
			'love_super',

			-- red rising sun
			'redrising_invisible',

			-- jspec
			'jspec_miracle',
			'jspec_miracle_together',
			'jspec_shout',

			-- dummy
			'random_stand'
		}
	},

	Deck = {
		items = {
			'fanworks_deck',
			'fanworks_act',
			'bone_shimmering',
			'gotequest_arcane',
		}
	},

	Sleeve = {
		items = {
			'sleeve_fanworks_deck',
			'sleeve_fanworks_act',
			'sleeve_bone_shimmering',
			'sleeve_gotequest_arcane',
		}
	},

	Voucher = {
		items = {
			'rubicon_kitty',
			'rubicon_parade',
			'streetlight_waystone',
			'streetlight_binding',
		}
	},

	Blind = {
		items = {
			'venus',
			'goat',
			'bolt',
			'rot',
			'box',
			'work',
			'written',
			'manga',
			'final_moe',
			'final_application',
			'final_multimedia',
		}
	},

	Challenge = {
		load_priority = -1,
		items = {
			'fanworks_beyond',
			'fanworks_bluesky',
			'fanworks_standoff',
			'fanworks_reread',
			'fanworks_moderated',
			'fanworks_corpse',
			'fanworks_comprehension',
			'fanworks_breakdown',
			'crimson_melting',
			'crimson_manager',
			'lighted_kriskross',
			'rubicon_foundation',
			'streetlight_shopping',
			'bluebolt_suggestion',
			'redrising_pyrrhic'
		}
	},

	Tag = {
		items = {
			'biased',
		}
	},

	Achievement = {
		items = {
			-- fan
			'fanworks_gyahoo',
			'fanworks_yur',
			'fanworks_property',
			'fanworks_sumo',
			'fanworks_tobad',
			'fanworks_nopowers',
			'fanworks_redacted',
			'fanworks_scan',
			'fanworks_artistic',
			'city_illiteracy',
			'gotequest_itgoes',
			'gotequest_city',
			'last_frances',
			'rockhard_welcome',
			'rockhard_gremmie',
			'rubicon_princess',
			'streetlight_criminals',
			'streetlight_salary',
			'mdv_birth',
			'upto0_mad',
			'jojojidai_1000',
			'redrising_damn',
			'redrising_found',
			'jspec_entrance',


			-- creator
			'fanworks_foty',
			'fanworks_50',
			'fanworks_original',
			'fanworks_hyperfixation',
			'fanworks_rejection',
			'fanworks_casual',
			'jojopolis_change',
			'bone_smells',
			'bone_type',
			'moscow_mixed',
			'crimson_american',
			'gotequest_meet',
			'culture_adapted',
			'glass_break',
			'rockhard_higher',
			'iron_strangers',
			'mania_white',
			'lighted_herring',
			'streetlight_daddy',
			'streetlight_everything',
			'sunshine_down',
			'sunshine_poly',
			'love_nevada',
			'voodoo_trinity',

			-- partner
			'fanworks_average',
			'gotequest_two',
			'spirit_empire',
			'spirit_reset',
			'double_down',
			'rubicon_picture',
			'bluebolt_again',
			'bluebolt_groupie',
			'jspec_clown',
			'jspec_generated',

			-- legacy
			'fanworks_conclusion',
			'fanworks_inked',
			'fanworks_newgame',
			'fanworks_superfan'
		}
	}
})