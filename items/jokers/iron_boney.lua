SMODS.DrawStep {
    key = 'boney',
    order = 92,
    func = function(self)
        if not self.config.center.discovered then
            return
        end

        if (not self.children.backing or not self.children.boned_bottom or not self.children.boned_top) or self.ability.boned then
            return
        end
        self.children.backing:draw_shader('dissolve')

        local cursor_pos = {}
        cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
        cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
        local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
        local shader_args = {}
        local hovering = (self.hover_tilt or 0)

        -- bottom effect values
        G.SHADERS['fnwk_boney_bottom']:send('mask_tex', G.ASSET_ATLAS['fnwk_boney_bottom_mask'].image)
        G.SHADERS['fnwk_boney_bottom']:send('mask_mod', self.ability.mask_mod)
        G.SHADERS['fnwk_boney_bottom']:send("texture_details", self.children.boned_bottom:get_pos_pixel())
        G.SHADERS['fnwk_boney_bottom']:send("image_details", self.children.boned_bottom:get_image_dims())
        G.SHADERS['fnwk_boney_bottom']:send('mouse_screen_pos', cursor_pos)
        G.SHADERS['fnwk_boney_bottom']:send('screen_scale', screen_scale)
        G.SHADERS['fnwk_boney_bottom']:send('hovering', hovering)
        love.graphics.setShader(G.SHADERS['fnwk_boney_bottom'], G.SHADERS['fnwk_boney_bottom'])
        self.children.boned_bottom:draw_self()

        -- top effect values
        G.SHADERS['fnwk_boney_top']:send('mask_tex', G.ASSET_ATLAS['fnwk_boney_top_mask'].image)
        G.SHADERS['fnwk_boney_top']:send('stencil', G.ASSET_ATLAS['fnwk_boney_stencil'].image)
        G.SHADERS['fnwk_boney_top']:send('mask_mod', 1)
        G.SHADERS['fnwk_boney_top']:send("texture_details", self.children.boned_top:get_pos_pixel())
        G.SHADERS['fnwk_boney_top']:send("image_details", self.children.boned_top:get_image_dims())
        G.SHADERS['fnwk_boney_top']:send('mouse_screen_pos', cursor_pos)
        G.SHADERS['fnwk_boney_top']:send('screen_scale', screen_scale)
        G.SHADERS['fnwk_boney_top']:send('hovering', hovering)
        love.graphics.setShader(G.SHADERS['fnwk_boney_top'], G.SHADERS['fnwk_boney_top'])
        self.children.boned_top:draw_self()

        love.graphics.setShader()
    end,
}

SMODS.Atlas({ key = 'boney_stencil', path = 'jokers/iron_boney_stencil.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'boney_top_mask', path = 'jokers/iron_boney_top_mask.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'boney_bottom_mask', path = 'jokers/iron_boney_bottom_mask.png', px = 71, py = 95 })

SMODS.Sound({key = "bad_to_the_bone", path = "bad_to_the_bone.ogg"})

local jokerInfo = {
    key = 'j_fnwk_iron_boney',
    name = 'Joker M.',
	config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.25,
        },
        boned = true,
        mask_mod = 0,
        mask_target = 0,
        inc_speed = 1,
    },
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'iron',
		},
        custom_color = 'iron',
    },
    artist = 'shaft'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_mod }}
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered and card.area ~= G.shop_jokers then
        return
    end

    if card.ability.boned then
        return
    end

    if card.ability.mask_mod < card.ability.mask_target then
        card.ability.mask_mod = card.ability.mask_mod + G.real_dt * card.ability.inc_speed
        if card.ability.mask_mod >= card.ability.mask_target then
            card.ability.mask_mod = card.ability.mask_target
        end
    end

    if not card.ability.initialized then
        card.ability.initialized = true

        play_sound('slice1')
        card:juice_up(0.2)
        card.ability.mask_target = 0.15
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.6,
            func = function()
                play_sound('slice1')
                card:juice_up(0.5)
                card.ability.mask_target = 0.45
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.2,
            func = function()
                play_sound('slice1')
                card:juice_up(1)
                card.ability.mask_target = 1
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.8,
            func = function()
                play_sound('slice1')
                -- destroy the animation sprites
                if card.children.boned_bottom then card.children.boned_bottom:remove() end
                if card.children.boned_top then card.children.boned_top:remove() end
                if card.children.backing then card.children.backing:remove() end

                card.children.boned_bottom = nil
                card.children.boned_top = nil
                card.children.backing = nil

                -- reset this card's base values
                card.ability.mask_mod = 0
                card.ability.mask_target = 0
                card.ability.boned = true
                card.late_center_draw = false
                card.children.center.scale = card.ability.old_scale
                card.T.w = card.ability.oldT.w
                card.T.h = card.ability.oldT.h
                card.ability.old_scale = nil
                card.ability.oldT = nil

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_boney'), colour = G.C.DARK_EDITION, sound = 'fnwk_bad_to_the_bone', delay = 1.3, no_juice = true})
                card:juice_up(1.4)
                G.ROOM.jiggle = G.ROOM.jiggle + 6
                return true
            end
        }))
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and not card.debuff and card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end

    if context.blueprint then return end

    if context.cardarea == G.jokers and context.removed_card == card and not card.debuff then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                local rand_joker = pseudorandom_element(G.jokers.cards, pseudoseed('boney'))
                if not rand_joker then return true end
                local rand_atlas = rand_joker.config.center.atlas
                local rand_pos = rand_joker.config.center.pos

                -- immediately replace with boney, forgoing any animation
                if rand_joker.config.center.key == 'j_fnwk_iron_sanctuary' then
                    check_for_unlock({type = 'fnwk_iron_strangers'})
                end
                ArrowAPI.game.transform_card(rand_joker, card.config.center.key, nil, true)

                rand_joker.ability.initialized = false
                rand_joker.ability.boned = false
                SMODS.scale_card(rand_joker, {
                    ref_table = rand_joker.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_mod",
                    no_message = true,
                })
                rand_joker.ability.perishable_compat = true
                rand_joker.ability.eternal_compat = true
                rand_joker.ability.old_scale = card.children.center.scale
                rand_joker.ability.oldT = card.T
                rand_joker.late_center_draw = true

                local atlas = rand_atlas and G.ASSET_ATLAS[rand_atlas] or G.ASSET_ATLAS['Joker']
                local role = {
                    role_type = 'Minor',
                    major = rand_joker,
                    offset = { x = 0, y = 0 },
                    xy_bond = 'Strong',
                    wh_bond = 'Strong',
                    r_bond = 'Strong',
                    scale_bond = 'Strong',
                    draw_major = rand_joker,
                }

                rand_joker.children.boned_bottom = Sprite(rand_joker.T.x, rand_joker.T.y, rand_joker.T.w, rand_joker.T.h, atlas, rand_pos)
                rand_joker.children.boned_bottom:set_role(role)
                rand_joker.children.boned_bottom.custom_draw = true

                rand_joker.children.boned_top = Sprite(rand_joker.T.x, rand_joker.T.y, rand_joker.T.w, rand_joker.T.h, atlas, rand_pos)
                rand_joker.children.boned_top:set_role(role)
                rand_joker.children.boned_top.custom_draw = true

                rand_joker.children.backing = Sprite(rand_joker.T.x, rand_joker.T.y, rand_joker.T.w, rand_joker.T.h, G.ASSET_ATLAS['fnwk_iron_boney'], {x = 1, y = 0})
                rand_joker.children.backing:set_role(role)
                rand_joker.children.backing.custom_draw = true

                -- place boney
                return true
            end
        }))
	end
end

return jokerInfo