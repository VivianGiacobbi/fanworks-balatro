local consumInfo = {
    name = 'Togetherland',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolved = true,
        aura_colors = { '6DD5FFDC', '89F7FFDC' },
    },
    cost = 4,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
    artist = 'plus',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.plus }}
    info_queue[#info_queue+1] = G.P_SEALS['blue_seal'] or G.P_SEALS[SMODS.Seal.badge_to_key['blue_seal'] or '']
    info_queue[#info_queue+1] = G.P_CENTERS.e_negative
end

return consumInfo