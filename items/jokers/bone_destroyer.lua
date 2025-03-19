SMODS.Atlas({ key = 'blank', path ='jokers/blank.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'noise', path ='noise.png', px = 128, py = 128 })

local jokerInfo = {
	name = 'Destroyer of Worlds',
	config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.1,
        },
        action_time = 0,
    },
    unlocked = false,
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
    fanwork = 'bone'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function jokerInfo.check_for_unlock(self, args)
    if not G.playing_cards then
        return false
    end
    
    local num_queens = 0
    for _, v in ipairs(G.playing_cards) do
        if v:get_id() == 12 then
            num_queens = num_queens + 1
            if not SMODS.has_enhancement(v, 'm_steel') then
                return false
            end
        end
    end

    if num_queens < 1 then
        return false
    end

    return true
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    -- foreground
    if not card.config.center.discovered then
        return
    end

    card.children.center:set_sprite_pos({x = 1, y = 0})
    
    local role = {
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	}
    
    card.children.action_lines = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['fnwk_blank'],
        { x = 0, y = 0}
    )
	card.children.action_lines:set_role(role)
	card.children.action_lines.custom_draw = true

    card.children.action_lines_2 = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['fnwk_blank'],
        { x = 0, y = 0}
    )
	card.children.action_lines_2:set_role(role)
	card.children.action_lines_2.custom_draw = true

    card.children.yoko_fore = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['fnwk_bone_destroyer'],
        { x = 2, y = 0}
    )
	card.children.yoko_fore:set_role(role)
	card.children.yoko_fore.custom_draw = true

    G.SHADERS['fnwk_speed_lines']:send('noise', G.ASSET_ATLAS['fnwk_noise'].image)
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then
        return
    end

    if context.individual and context.cardarea == G.play and not context.other_card.debuff 
    and card.ability.extra.x_mult > 1 and context.other_card:get_id() == 12 then
        return {
            Xmult = card.ability.extra.x_mult,
            card = context.blueprint_card or card
        }
    end


    if context.blueprint or not (context.reroll_shop and context.cardarea == G.jokers) then
        return
    end

    card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
    return {
        message = localize('k_upgrade_ex'),
        card = card,
    }
end

function jokerInfo.draw(self, card, layer)

    if not card.config.center.discovered or not card.children.action_lines then
        return
    end

    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)

    G.SHADERS['fnwk_speed_lines']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_speed_lines']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_speed_lines']:send('hovering', hovering)

    card.ability.action_time = card.ability.action_time + G.real_dt

    G.SHADERS['fnwk_speed_lines']:send('color', HEX('23B2DC30'))  
    G.SHADERS['fnwk_speed_lines']:send('time', card.ability.action_time)
    G.SHADERS['fnwk_speed_lines']:send('texture_details', card.children.action_lines:get_pos_pixel())
    G.SHADERS['fnwk_speed_lines']:send('image_details', card.children.action_lines:get_image_dims())

    G.SHADERS['fnwk_speed_lines']:send('line_count', 0.6)
    G.SHADERS['fnwk_speed_lines']:send('line_density', 0.6)
    G.SHADERS['fnwk_speed_lines']:send('line_falloff', 0.5)
    G.SHADERS['fnwk_speed_lines']:send('mask_size', 0.53)
    G.SHADERS['fnwk_speed_lines']:send('mask_edge', 0.38)
    G.SHADERS['fnwk_speed_lines']:send('speed', 5.5)

    love.graphics.setShader(G.SHADERS['fnwk_speed_lines'], G.SHADERS['fnwk_speed_lines'])
    card.children.action_lines:draw_self()

    -- action lines 2
    G.SHADERS['fnwk_speed_lines']:send('color', HEX('23B2DCBC'))  
    G.SHADERS['fnwk_speed_lines']:send('time', card.ability.action_time + math.random(1, 3))
    G.SHADERS['fnwk_speed_lines']:send('texture_details', card.children.action_lines_2:get_pos_pixel())
    G.SHADERS['fnwk_speed_lines']:send('image_details', card.children.action_lines_2:get_image_dims())

    G.SHADERS['fnwk_speed_lines']:send('line_count', 0.9)
    G.SHADERS['fnwk_speed_lines']:send('line_density', 0.6)
    G.SHADERS['fnwk_speed_lines']:send('line_falloff', 1)
    G.SHADERS['fnwk_speed_lines']:send('mask_size', 0.4)
    G.SHADERS['fnwk_speed_lines']:send('mask_edge', 0.28)
    G.SHADERS['fnwk_speed_lines']:send('speed', 8)

    card.children.action_lines_2:draw_self()

    G.SHADERS['fnwk_basic']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_basic']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_basic']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_basic'], G.SHADERS['fnwk_basic'])
    card.children.yoko_fore:draw_self()

    love.graphics.setShader()
end

return jokerInfo
