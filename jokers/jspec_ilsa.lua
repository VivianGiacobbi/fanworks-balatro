SMODS.Atlas({ key = 'jspec_ilsa_stars', path = 'jokers/jspec_ilsa_stars.png', px = 71, py = 95 })

local jokerInfo = {
	key = 'j_fnwk_jspec_ilsa',
    name = 'Ilsa',
	config = {},
	rarity = 4,
	cost = 20,
    hasSoul = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jspec'
}

-- update multi-edition status for cards that are already in the deck or joker slots
local function update_multi_editions(card, enable_multi)
    if not card.edition then 
        return
    end

    card:set_edition(card.edition.key, true, true, enable_multi)
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS['e_holo']
    info_queue[#info_queue+1] = G.P_CENTERS['e_foil']
    info_queue[#info_queue+1] = G.P_CENTERS['e_polychrome']
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    card.children.ilsa_stars = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['fnwk_jspec_ilsa_stars'],
        { x = 0, y = 0 }
    )	
	card.children.ilsa_stars:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card,
    })
    card.children.ilsa_stars.custom_draw = true
end


function jokerInfo.add_to_deck(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        update_multi_editions(v, true)
    end

    for _, v in ipairs(G.jokers.cards) do
        update_multi_editions(v, true)
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        update_multi_editions(v, false)
    end

    for _, v in ipairs(G.jokers.cards) do
        update_multi_editions(v, false)
    end
end

function jokerInfo.draw(self, card, layer)
    if not (card.config.center.discovered or card.bypass_discovery_center) or not card.children.ilsa_stars then
        return
    end

    local offset_timer = G.TIMERS.REAL + 1
    local scale_mod = 0.08 + 0.02*math.sin(1.8*offset_timer) + 0.00*math.sin((offset_timer - math.floor(offset_timer))*math.pi*14)*(1 - (offset_timer - math.floor(offset_timer)))^3
    local rotate_mod = 0.12*math.sin(1.219*offset_timer) + 0.00*math.sin((offset_timer)*math.pi*5)*(1 - (offset_timer - math.floor(offset_timer)))^2

    card.children.ilsa_stars:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, nil, 0.1 + 0.03*math.sin(1.8*offset_timer), nil, 0.6)
    card.children.ilsa_stars:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
    local edition = card.edition and G.P_CENTERS[card.edition.key] or nil
    if edition and edition.apply_to_float then 
        
        self.children.ilsa_stars:draw_shader(edition.shader, nil, nil, nil, card.children.center, scale_mod, rotate_mod)
    end
end

return jokerInfo