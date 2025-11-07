SMODS.Atlas({ key = 'love_jokestar_neon', path = 'jokers/love_jokestar_neon.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'love_jokestar_front', path = 'jokers/love_jokestar_front.png', px = 71, py = 95 })

local jokerInfo = {
    key = 'j_fnwk_love_jokestar',
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
        glow_intensity = 2,
        glow_threshold = 0.96,
        glow_size = 0.95,
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'love',
		},
        custom_color = 'love',
    },
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod }}
end


function jokerInfo.calculate(self, card, context)
    if context.joker_main and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card
        }
    end

    if context.after and not context.blueprint then
        if hand_chips*mult > G.GAME.blind.chips then
            G.GAME.fnwk_love_scale_round = true
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
            })
        end
    end

    if context.end_of_round and context.main_eval then
        if G.GAME.fnwk_love_scale_round then
            G.GAME.fnwk_love_consec_scales = (G.GAME.fnwk_love_consec_scales or 0) + 1
            if G.GAME.fnwk_love_consec_scales >= 10 then
                check_for_unlock({type = 'fnwk_love_nevada'})
            end
        else
            G.GAME.fnwk_love_scale_round  = nil
        end
    end
end

function jokerInfo.set_sprites(self, card, front)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if card.children.fnwk_love_neon then card.children.fnwk_love_neon:remove() end
    if card.children.fnwk_love_front then card.children.fnwk_love_front:remove() end

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

    local atlas_2 = G.ASSET_ATLAS['fnwk_love_jokestar_neon']
	card.children.fnwk_love_neon = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas_2, { x = 0, y = 0 })
	card.children.fnwk_love_neon:set_role(role)
    card.children.fnwk_love_neon.glow_color = {0, 0.92, 1}
    card.children.fnwk_love_neon.custom_draw = true

    local atlas_1 = G.ASSET_ATLAS['fnwk_love_jokestar_front']
    card.children.fnwk_love_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas_1, { x = 0, y = 0 })
	card.children.fnwk_love_front:set_role(role)
    card.children.fnwk_love_front.custom_draw = true

    card.late_center_draw = true
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
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


    local ease = ArrowAPI.math.ease_funcs.in_out_sin(card.ability.glow_lerp)
    card.ability.glow_intensity = 3 * (ease * card.ability.glow_range + card.ability.glow_min)
    card.ability.glow_size = 0.94 * (ease * card.ability.glow_range + card.ability.glow_min)
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if not (card.children.fnwk_love_neon and card.children.fnwk_love_front) then
        return
    end

    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)

    if card.ability.fizzled then
        card.ability.glow_size = card.ability.glow_size - G.real_dt * 40
        card.ability.glow_intensity = card.ability.glow_intensity - G.real_dt * 100
        if card.ability.glow_size <= 0 and card.ability.glow_intensity <= 0 then
            card.children.fnwk_love_front:draw_shader('dissolve')
            return
        end
    else
        G.SHADERS['fnwk_bloom']:send('glow_colour', card.children.fnwk_love_neon.glow_color)
        G.SHADERS['fnwk_bloom']:send('bloom_size', card.ability.glow_size)
        G.SHADERS['fnwk_bloom']:send('bloom_intensity', card.ability.glow_intensity)
        G.SHADERS['fnwk_bloom']:send('bloom_threshold', card.ability.glow_threshold)
        G.SHADERS['fnwk_bloom']:send('mouse_screen_pos', cursor_pos)
        G.SHADERS['fnwk_bloom']:send('screen_scale', screen_scale)
        G.SHADERS['fnwk_bloom']:send('hovering', hovering)
        love.graphics.setShader(G.SHADERS['fnwk_bloom'], G.SHADERS['fnwk_bloom'])
        card.children.fnwk_love_neon:draw_self()
        love.graphics.setShader()
    end

    card.children.fnwk_love_front:draw_shader('dissolve')
end

return jokerInfo