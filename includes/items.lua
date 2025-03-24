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
		'plancks_crazy',

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
		'lighted_gypsy',
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
		'rubicon_film',
		'rubicon_moonglass',
		'rubicon_bone',

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
		'bluebolt_sexy',
		'bluebolt_secluded',
		'bluebolt_tuned',
		'bluebolt_impaired',

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
		'fanworks_bathroom'
	},

	Consumable = {
		'spec_stonemask',
	},
	
	Deck = {
		'fanworks',
	},

	Voucher = {
		'rubicon_kitty',
    	'rubicon_parade'
	},

	Challenge = {
		--'tucker',
	},

	Blind = {
		--'hog',
		--'tray',
		--'vod',
		--'finger',
		--'mochamike',
	},

	Stand = {

	}
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

local wip_jokers = {
    ['fanworks_fanworks'] = true,
    ['fanworks_standoff'] = true,
	['jojopolis_high'] = true,
    ['asap_jokestar'] = true,
    ['gotequest_pair'] = true,
    ['gotequest_2hot'] = true,
    ['gotequest_ajorekesr'] = true,
    ['gotequest_will'] = true,
    ['last_morse'] = true,
    ['rockhard_vasos'] = true,
    ['iron_sanctuary'] = true,
    ['lighted_gypsy'] = true,
    ['mania_jokestar'] = true,
	['mania_fragile'] = true,
	['industry_loyal'] = true,
	['spirit_gambler'] = true,
	['double_firewalker'] = true,
	['streetlight_arrow'] = true,
	['streetlight_biased'] = true,
	['streetlight_teenage'] = true,
	['whiplash_quiet'] = true,
	['bluebolt_impaired'] = true,
	['noman_unknown'] = true,
	['jspec_energetic'] = true,
	['jspec_seal'] = true,
}

for k, v in pairs(items_to_load) do
	if next(items_to_load[k]) and fnwk_enabled['enable'..k..'s'] then
		for i = 1, #v do
			
			if not wip_jokers[v[i]] or (wip_jokers[v[i]] and fnwk_enabled['enableWipJokers']) then
				LoadItem(v[i], k)

				if k == 'Joker' and alt_jokers[v[i]] then
					SMODS.Atlas({ key = v[i]..'_alt', path = "jokers/" .. v[i] .. '_alt'.. ".png", px = 71, py = 95 })
				end
			end
		end
	end
end

-- Stand Consumable
SMODS.Atlas({ key = 'fnwk_undiscovered', path ="undiscovered.png", px = 71, py = 95 })
if items_to_load.Stand and #items_to_load.Stand > 0 then
    G.C.STAND = HEX('b85f8e')
    SMODS.ConsumableType {
        key = "Stand",
        primary_colour = G.C.STAND,
        secondary_colour = G.C.STAND,
        collection_rows = { 8, 8 },
        shop_rate = 0,
        loc_txt = {},
        default = "c_fnwk_blackspine",
        can_stack = false,
        can_divide = false,
    }

    SMODS.UndiscoveredSprite {
        key = "Stand",
        atlas = "fnwk_undiscovered",
        pos = { x = 0, y = 0 }
    }
end