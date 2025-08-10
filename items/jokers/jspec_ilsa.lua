SMODS.Atlas({ key = 'jspec_ilsa_sun', path = 'jokers/jspec_ilsa_sun.png', px = 17, py = 17 })
SMODS.Atlas({ key = 'jspec_ilsa_star', path = 'jokers/jspec_ilsa_star.png', px = 11, py = 11 })

local jokerInfo = {
    name = 'Ilsa',
	config = {},
	rarity = 4,
	cost = 20,
    hasSoul = true,
    unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
    artist = 'mal'
}

-- update multi-edition status for cards that are already in the deck or joker slots
local function update_multi_editions(card)
    if not card.edition then
        return
    end

    card:set_edition(card.edition.key, true, true)
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS['e_holo']
    info_queue[#info_queue+1] = G.P_CENTERS['e_foil']
    info_queue[#info_queue+1] = G.P_CENTERS['e_polychrome']
    return { vars = { fnwk_enabled['enable_Queer'] and 'Queer' or 'Polychrome' } }
end

function jokerInfo.set_sprites(self, card, front)
    if (not card.config.center.discovered and card.area ~= G.shop_jokers) then
        return
    end

    local role = {
		role_type = 'Major',
        draw_major = card,
    }

    local center_atlas = G.ASSET_ATLAS['fnwk_jspec_ilsa']
    local sun_atlas = G.ASSET_ATLAS['fnwk_jspec_ilsa_sun']
    card.children.ilsa_sun = Sprite(
        card.T.x,
        card.T.y,
        card.T.w * (sun_atlas.px / center_atlas.px),
        card.T.h * (sun_atlas.py / center_atlas.py),
        sun_atlas,
        { x = 0, y = 0 }
    )
	card.children.ilsa_sun:set_role(role)
    card.children.ilsa_sun:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.1},
        {shader = 'dissolve'}
	})

    local star_atlas = G.ASSET_ATLAS['fnwk_jspec_ilsa_star']
    card.children.ilsa_star_1 = Sprite(
        card.T.x,
        card.T.y,
        card.T.w * (star_atlas.px / center_atlas.px),
        card.T.h * (star_atlas.py / center_atlas.py),
        star_atlas,
        { x = 0, y = 0 }
    )
	card.children.ilsa_star_1:set_role(role)
    card.children.ilsa_star_1:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.1},
        {shader = 'dissolve'}
	})

    card.children.ilsa_star_2 = Sprite(
        card.T.x,
        card.T.y,
        card.T.w * (star_atlas.px / center_atlas.px),
        card.T.h * (star_atlas.py / center_atlas.py),
        star_atlas,
        { x = 0, y = 0 }
    )
	card.children.ilsa_star_2:set_role(role)
    card.children.ilsa_star_2:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.1},
        {shader = 'dissolve'}
	})

    --[[
    card.children.particles = Particles(
        card.T.x, 
        card.T.y, 
        0, 
        0, 
        {
            timer_type = 'TOTAL',
            timer = 0.1,
            scale = 0.2,
            speed = 0,
            r_vel = 0,
            fade_alpha = 0.5,
            lifespan = 0.3,
            colours = {{1,1,1,0.8}},
            attach = card.children.ilsa_star_1,
            fill = true,
        })
    --]]
end


function jokerInfo.add_to_deck(self, card, from_debuff)
    G.force_ilsa = true
    for _, v in ipairs(G.playing_cards) do
        update_multi_editions(v)
    end

    for _, v in ipairs(G.jokers.cards) do
        update_multi_editions(_VERSION)
    end
    G.force_ilsa = false
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        update_multi_editions(v)
    end

    for _, v in ipairs(G.jokers.cards) do
        update_multi_editions(v)
    end
end

function jokerInfo.draw(self, card, layer)
    if not (card.config.center.discovered or card.bypass_discovery_center) then
        return
    end

    if not (card.children.ilsa_star_1 and card.children.ilsa_star_2 and card.children.ilsa_sun) then
        return
    end

    local star_1 = card.children.ilsa_star_1
    local star_2 = card.children.ilsa_star_2
    local sun = card.children.ilsa_sun
    local star_1_alpha = (G.TIMERS.REAL + 1) * 1.6 % (2 * math.pi)
    local star_2_alpha = (G.TIMERS.REAL + 5) * 1.4 % (2 * math.pi)
    local sun_alpha = (G.TIMERS.REAL + 3) * 0.8 % (2 * math.pi)

    local card_offset_x = card.T.x + card.T.w / 2
    local card_offset_y = card.T.y + card.T.h / 2
    star_1.T.x = card_offset_x + (math.cos(star_1_alpha) * card.T.w / 2 * 0.6) - star_1.T.w / 2
    star_1.T.y = card_offset_y + (math.sin(star_1_alpha) * card.T.h / 2 * 0.6) - star_1.T.h / 2

    star_2.T.x = card_offset_x + (math.cos(star_2_alpha) * card.T.w / 2 * 0.9) - star_2.T.w / 2
    star_2.T.y = card_offset_y + (math.sin(star_2_alpha) * card.T.h / 2 * 0.9) - star_2.T.h / 2

    sun.T.x = card_offset_x + (math.cos(sun_alpha) * card.T.w / 2 * 0.8) - sun.T.w / 2
    sun.T.y = card_offset_y + (math.sin(sun_alpha) * card.T.h / 2 * 0.8) - sun.T.h / 2 
end

return jokerInfo