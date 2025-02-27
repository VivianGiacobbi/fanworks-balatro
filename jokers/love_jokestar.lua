SMODS.Atlas({ key = 'neonsign_1', path = 'jokers/love_jokestar_sign_1.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'neonsign_2', path = 'jokers/love_jokestar_sign_2.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'neonsign_3', path = 'jokers/love_jokestar_sign_3.png', px = 71, py = 95 })

local jokerInfo = {
    key = 'j_fnwk_loveonce_jokestar',
	name = 'Prideful Jokestar',
	config = {
        extra = {
            mult = 0,
            mult_mod = 4,
        },
        fizzle_timer = 0,
        fizzle_check = 0.18,
        fizzle_limit = 0.13,
        base_fizzle_chance = 0.025,
        consecutive_mod = 15,
        fizzle_chance = 0.025,
        consecutive_limit = 2,
        consecutive_fizzles = 0,
        glow_intensity = 4,
        glow_threshold = 0.95,
        glow_size = 0.95,
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'love',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod }}
end


function jokerInfo.calculate(self, card, context)
    
    if context.cardarea == G.jokers and context.joker_main then
        if card.ability.extra.mult > 0 then
            return {
				message = localize{ type='variable', key='a_mult', vars = {card.ability.extra.mult} },
                mult_mod = card.ability.extra.mult,
				colour = G.C.MULT
			}
        end
    end
    
    if context.cardarea == G.jokers and context.final_scoring_step then
        if hand_chips*mult > G.GAME.blind.chips then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
        end
    end
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    local role = {
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card,
    }
    card.ability.fizzle_timer = 0
    card.ability.fizzle_check = 0.18
    card.ability.fizzle_limit = 0.13
    card.ability.base_fizzle_chance = 0.025
    card.ability.consecutive_mod = 15
    card.ability.fizzle_chance = card.ability.base_fizzle_chance
    card.ability.consecutive_limit = math.random(1, 4)
    card.ability.consecutive_fizzles = 0

    card.ability.glow_intensity = 4
    card.ability.glow_threshold = 0.95
    card.ability.glow_size = 0.95

    local sign_atlas_1 = G.ASSET_ATLAS['fnwk_neonsign_1']
	card.children.bloom1 = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, sign_atlas_1,{ x = 0, y = 0 })	
	card.children.bloom1:set_role(role)
    card.children.bloom1.glow_color = {1, 0.96, 0}
    card.children.bloom1.custom_draw = true

    local sign_atlas_2 = G.ASSET_ATLAS['fnwk_neonsign_2']
    card.children.bloom2 = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, sign_atlas_2,{ x = 0, y = 0 })	
	card.children.bloom2:set_role(role)
    card.children.bloom2.glow_color = {0, 0.92, 1}
    card.children.bloom2.custom_draw = true

    local sign_atlas_3 = G.ASSET_ATLAS['fnwk_neonsign_3']
    card.children.bloom3 = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, sign_atlas_3,{ x = 0, y = 0 })	
	card.children.bloom3:set_role(role)
    card.children.bloom3.glow_color = {1, 0.07, 0.05}
    card.children.bloom3.custom_draw = true
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered then
        return
    end


    if card.ability.fizzled then
        if card.ability.fizzle_timer < card.ability.fizzle_limit then 
            card.ability.fizzle_timer = card.ability.fizzle_timer + G.real_dt
            if card.ability.fizzle_timer >= card.ability.fizzle_limit then
                card.ability.fizzled = false
                card.ability.fizzle_timer = 0
            end
        end

        if card.ability.fizzled then
            return
        end
    end

    if card.ability.fizzle_timer < card.ability.fizzle_check then
        card.ability.fizzle_timer = card.ability.fizzle_timer + G.real_dt
        if card.ability.fizzle_timer >= card.ability.fizzle_check then
            if math.random() < card.ability.fizzle_chance then
                if card.ability.consecutive_fizzles > card.ability.consecutive_limit then
                    card.ability.fizzle_chance = card.ability.base_fizzle_chance
                    card.ability.consecutive_fizzles = 0
                    card.ability.consecutive_limit = math.random(1, 4)
                else
                    card.ability.fizzle_chance = card.ability.base_fizzle_chance * card.ability.consecutive_mod
                end
                card.ability.fizzled = true
                card.ability.consecutive_fizzles = card.ability.consecutive_fizzles + 1
                card.ability.fizzle_limit = math.random() * 0.3 + 0.11
                card.ability.fizzle_timer = 0
                return
            end
            card.ability.fizzle_timer = 0
        end
    end 

    if not card.ability.glow_initialized then
		card.ability.glow_direction = 1
		card.ability.glow_lerp = 0
        card.ability.glow_max = 1.15
        card.ability.glow_min = 1
        card.ability.glow_range = card.ability.glow_max - card.ability.glow_min

		card.ability.glow_initialized = true
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
			card.ability.glow_initialized = false
		end
	end

    
    local ease = EaseInOutSin(card.ability.glow_lerp)
    card.ability.glow_intensity = 4 * (ease * card.ability.glow_range + card.ability.glow_min)
    card.ability.glow_size = 0.95 * (ease * card.ability.glow_range + card.ability.glow_min)
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered then
        return
    end
    
    if not (card.children.bloom1 and card.children.bloom2 and card.children.bloom3) then
        return
    end

    if card.ability.fizzled then
        card.ability.glow_size = card.ability.glow_size - G.real_dt * 40
        card.ability.glow_intensity = card.ability.glow_intensity - G.real_dt * 100
        if card.ability.glow_size <= 0 and card.ability.glow_intensity <= 0 then
            return
        end
    end


    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)

    G.SHADERS['fnwk_bloom']:send('bloom_size', card.ability.glow_size)
    G.SHADERS['fnwk_bloom']:send('bloom_intensity', card.ability.glow_intensity)
    G.SHADERS['fnwk_bloom']:send('bloom_threshold', card.ability.glow_threshold)
    G.SHADERS['fnwk_bloom']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_bloom']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_bloom']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_bloom'], G.SHADERS['fnwk_bloom'])
    G.SHADERS['fnwk_bloom']:send('glow_colour', card.children.bloom1.glow_color)
    card.children.bloom1:draw_self()
    G.SHADERS['fnwk_bloom']:send('glow_colour', card.children.bloom2.glow_color)
    card.children.bloom2:draw_self()
    G.SHADERS['fnwk_bloom']:send('glow_colour', card.children.bloom3.glow_color)
    card.children.bloom3:draw_self()
    love.graphics.setShader()
end

return jokerInfo