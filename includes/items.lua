SMODS.ObjectType {
    default = 'j_fnwk_bluebolt_sexy',
    key = 'fnwk_women',
	cards = {
		['j_lusty_joker'] = true,
        ['j_blueprint'] = true,
        ['j_brainstorm'] = true,
        ['j_shoot_the_moon'] = true,
        ['j_fnwk_plancks_unsure'] = true,
        ['j_fnwk_rubicon_moonglass'] = true,
        ['j_fnwk_streetlight_fledgling'] = true,
        ['j_fnwk_streetlight_indulgent'] = true,
        ['j_fnwk_streetlight_industrious'] = true,
        ['j_fnwk_streetlight_methodical'] = true,
        ['j_fnwk_rubicon_thnks'] = true,
        ['j_fnwk_streetlight_resil'] = true,
        ['j_fnwk_bone_destroyer'] = true,
        ['j_fnwk_industry_loyal'] = true,
        ['j_fnwk_mania_jokestar'] = true,
        ['j_fnwk_gotequest_killing'] = true,
        ['j_fnwk_jspec_joepie'] = true,
        ['j_fnwk_jspec_ilsa'] = true,
        ['j_fnwk_bluebolt_tuned'] = true,
        ['j_fnwk_love_holy'] = true,
        ['j_drivers_license'] = true,
        ['j_fnwk_rockhard_rebirth'] = true,
        ['j_fnwk_bluebolt_sexy'] = true,
        ['j_fnwk_bluebolt_secluded'] = true,
        ['j_fnwk_plancks_ghost'] = true,
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
		['c_fnwk_spec_ichor'] = true,
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
			'spirit_raise',
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

			-- love once buried
			'love_jokestar',
			'love_holy',

			-- my digital venus
			'mdv_shock',

			-- jojojidai
			'jojojidai_soldiers',

			-- lipstick_vogue
			'lipstick_bronx',

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
			'spec_ichor',
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
			'gotequest_born',
			'gotequest_sweet',
			'gotequest_takyon',

			'culture_starboy',

			-- glass lariats
			'glass_big',

			-- plancks creek
			'plancks_moon',

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

			-- jojomania
			'mania_moving',

			-- spirit lines
			'spirit_achtung',
			'spirit_achtung_stranger',
			'spirit_sweet',
			'spirit_ultimate',

			-- closer 2 god
			'closer_artificial',

			-- double down
			'double_wine',
			'double_geometrical',

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

			-- whiplash riot
			'whiplash_never',

			-- bluebolt incarnation
			'bluebolt_thunder',
			'bluebolt_thunder_dc',
			'bluebolt_chemical',
			'bluebolt_insane',
			
			-- sunshine deluxe
			'sunshine_electric',
			'sunshine_damned',
			'sunshine_downward',
			'sunshine_red',

			-- scepter files
			'scepter_lenfer',

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
			'bone_shimmering',
			'gotequest_arcane',
			'fanworks_act',
		}
	},

	Sleeve = {
		items = {
			'sleeve_fanworks_deck'
		}
	},

	Voucher = {
		items = {
			'rubicon_kitty',
			'rubicon_parade',
			'streetlight_waystone',
			'streetlight_binding',
			'spirit_binary',
			'spirit_prime',
			'sunshine_rapture',
			'sunshine_totality'
		}
	},

	Blind = {
		items = {
			'venus',
			'goat',
			'bolt',
			'rot',
			'creek',
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
			--'fanworks_invisible',
			'fanworks_comprehension',
			'fanworks_breakdown',
			'crimson_melting',
			'crimson_manager',
			'lighted_kriskross',
			'spirit_creeping',
			'rubicon_foundation',
		}
	},

	Tag = {
		items = {
			'biased',
		}
	}
})

