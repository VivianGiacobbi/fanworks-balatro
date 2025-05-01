local jokerInfo = {
	name = 'NEET Jokestar',
	config = {
		extra = {
			x_mult = 3
		},
        scroll_dist = 0.17,
        scroll_mod = 0.35,
        layer1_mod = 0.15,
        layer2_mod = 0.40,
        layer3_mod = 1,
        city_dir = 1,
		city_lerp = 0
	},
	rarity = 2,
	cost = 6,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'city'
}

local function joker_name_mod(card)
    if not G.jokers then
        return 1
    end

    local mod = card.ability.extra.x_mult

    for i=1, #G.jokers.cards do
        local name = string.lower(G.jokers.cards[i].config.center.name)
        if G.jokers.cards[i] ~= card and (string.find(name, 'joker') or string.find(name, 'jokestar')) then
            mod = 1
            break
        end
    end

    return mod
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.mal }}
    return { vars = { card.ability.extra.x_mult, joker_name_mod(card) } }
end

function jokerInfo.set_sprites(self, card, front)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    local t = {x = card.T.x, y = card.T.y, w = card.T.w, h = card.T.h}
    local major_role = {
		role_type = 'Major',
        draw_major = card,
    }

    -- foreground
    local atlas = G.ASSET_ATLAS['fnwk_city_neet']
    --[[
    card.children.city_bkg = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 3, y = 0})
	card.children.city_bkg:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.city_bkg.custom_draw = true
    --]]

    -- first layer
	card.children.city_layer1 = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 4, y = 0})
	card.children.city_layer1:set_role(major_role)
    card.children.city_layer1.custom_draw = true

    -- second layer
    card.children.city_layer2 = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 5, y = 0})
	card.children.city_layer2:set_role(major_role)
	card.children.city_layer2.custom_draw = true

    -- third layer
    card.children.city_layer3 = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 6, y = 0})
	card.children.city_layer3:set_role(major_role)
	card.children.city_layer3.custom_draw = true
    
    -- foreground
    card.children.city_fg = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 7, y = 0})
	card.children.city_fg:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.city_fg.custom_draw = true
    card.late_center_draw = true
end

function jokerInfo.calculate(self, card, context)
	if not (context.cardarea == G.jokers and context.joker_main) or card.debuff then
		return
	end

    local mult_mod = joker_name_mod(card)
	if mult_mod > 1 then
		return {
			message = localize{type='variable',key='a_xmult',vars={mult_mod}},
			card = context.blueprint_card or card,
			Xmult_mod = mult_mod,
		}
	end
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if not card.ability then
        return
    end

    -- lerping right
	if card.ability.city_dir > 0 and card.ability.city_lerp < 1 then
		card.ability.city_lerp = card.ability.city_lerp + G.real_dt * card.ability.scroll_mod
		
		if (card.ability.city_lerp >= 1) then
			card.ability.city_lerp = 1
			card.ability.city_dir = -1
		end
	end

    -- lerping left
	if card.ability.city_dir < 0 and card.ability.city_lerp > 0 then
		card.ability.city_lerp = card.ability.city_lerp - G.real_dt * card.ability.scroll_mod
		if (card.ability.city_lerp <= 0) then
			card.ability.city_lerp = 0
			card.ability.city_dir = 1
		end
	end    
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if not card.ability then
        return
    end

    local shader_args = {}
    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)
    shader_args[1] = {name = 'mouse_screen_pos', val = cursor_pos}
    shader_args[2] = {name = 'hovering', val = hovering}
    shader_args[3] = {name = 'screen_scale', val = screen_scale}

    local lerp_val = FnwkEaseInOutQuart(card.ability.city_lerp)
    local scroll_dist = card.ability.scroll_dist / 2
    if lerp_val > 0.5 then
        scroll_dist = scroll_dist * (lerp_val - 0.5) / 0.5
    else
        scroll_dist = -1 * scroll_dist * (0.5 - lerp_val) / 0.5
    end
    
    -- foreground
    -- card.children.city_bkg:draw_shader('fnwk_basic', nil, shader_args, nil, nil, nil, nil, nil, nil, true, true)

    -- first layer
    card.children.city_layer1.T = copy_table(card.T)
    card.children.city_layer1.VT = copy_table(card.VT)
    card.children.city_layer1.VT.x = card.VT.x + scroll_dist * card.ability.layer1_mod
	card.children.city_layer1:draw_shader('fnwk_basic', nil, shader_args, nil, nil, nil, nil, nil, nil, true, true)

    -- second layer
    card.children.city_layer2.T = copy_table(card.T)
    card.children.city_layer2.VT = copy_table(card.VT)
    card.children.city_layer2.VT.x = card.VT.x + scroll_dist * card.ability.layer2_mod
    card.children.city_layer2:draw_shader('fnwk_basic', nil, shader_args, nil, nil, nil, nil, nil, nil, true, true)

    -- third layer
    card.children.city_layer3.T = copy_table(card.T)
    card.children.city_layer3.VT = copy_table(card.VT)
    card.children.city_layer3.VT.x = card.VT.x + scroll_dist * card.ability.layer3_mod
    card.children.city_layer3:draw_shader('fnwk_basic', nil, shader_args, nil, nil, nil, nil, nil, nil, true, true)
    
    -- foreground
    -- function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    card.children.city_fg:draw_shader('fnwk_basic', nil, shader_args, nil, nil, nil, nil, nil, nil, true, true)
end


return jokerInfo