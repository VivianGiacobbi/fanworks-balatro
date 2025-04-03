SMODS.Atlas({ key = 'double_devastation_glow', path = 'jokers/double_devastation_glow.png', px = 71, py = 95 })

local jokerInfo = {
	name = 'The Devastation',
    config = {
        extra = {
            h_size = 3,
            a_mult = 100
        },
        glow_direction = 1,
        glow_lerp = 0,
        glow_max = 1,
        glow_min = 0.40,
        glow_range = 0.6,
    },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'double',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_notdaedalus", set = "Other"}
    return { vars = { card.ability.extra.h_size, card.ability.extra.a_mult} }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    card.ability.glow_range = card.ability.glow_max - card.ability.glow_min
    card.ability.glow_intensity = 2.4
    card.ability.glow_threshold = 0.95
    card.ability.glow_size = 1

    card.config.center.pos = { x = 1, y = 0 }
    card:set_sprites(card.config.center)
end

function jokerInfo.load(self, card, card_table, other_card)
    card.config.center.pos = { x = 1, y = 0 }
    card:set_sprites(card.config.center)
end

function jokerInfo.set_sprites(self, card, front)
    if not card.config.center.discovered then
        return
    end

    if card.children.dev_glow then card.children.dev_glow:remove() end

    local dev_atlas = G.ASSET_ATLAS['fnwk_double_devastation_glow']
	card.children.dev_glow = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, dev_atlas, { x = 0, y = 0 })	
	card.children.dev_glow:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card,
    })
    card.children.dev_glow.glow_color = {1, 0.17, 0.20}
    card.children.dev_glow.custom_draw = true
    card.late_center_draw = true
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        return {
            message = localize{type='variable', key='a_mult', vars = {card.ability.extra.a_mult} },
            mult_mod = card.ability.extra.a_mult,
            colour = G.C.MULT,
            card = context.blueprint_card or card
        }
    end
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered then
        return
    end

    if card.ability.glow_direction > 0 and card.ability.glow_lerp < 1 then
        card.ability.glow_lerp = card.ability.glow_lerp + G.real_dt
		if (card.ability.glow_lerp >= 1) then
			card.ability.glow_lerp = 1
			card.ability.glow_direction = -1
		end
	end

	if card.ability.glow_direction < 0 and card.ability.glow_lerp > 0 then
		card.ability.glow_lerp = card.ability.glow_lerp - G.real_dt
		if (card.ability.glow_lerp <= 0) then
			card.ability.glow_lerp = 0
			card.ability.glow_direction = 1
		end
	end
    
    local ease = EaseInOutSin(card.ability.glow_lerp)
    card.ability.glow_intensity = 2.4 * (ease * card.ability.glow_range + card.ability.glow_min)
    card.ability.glow_size = 1.2 * (ease * card.ability.glow_range + card.ability.glow_min)
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered then
        return
    end

    if not card.children.dev_glow then
        return
    end

    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)

    G.SHADERS['fnwk_bloom']:send('bloom_size', card.ability.glow_size)
    G.SHADERS['fnwk_bloom']:send('bloom_intensity', card.ability.glow_intensity)
    G.SHADERS['fnwk_bloom']:send('bloom_threshold', card.ability.glow_threshold)
    G.SHADERS['fnwk_bloom']:send('glow_colour', card.children.dev_glow.glow_color)
    G.SHADERS['fnwk_bloom']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_bloom']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_bloom']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_bloom'], G.SHADERS['fnwk_bloom'])
    card.children.dev_glow:draw_self()
    love.graphics.setShader()
end

return jokerInfo
