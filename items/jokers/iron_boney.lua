SMODS.Atlas({ key = 'boney_stencil', path = 'jokers/iron_boney_stencil.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'boney_top_mask', path = 'jokers/iron_boney_top_mask.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'boney_bottom_mask', path = 'jokers/iron_boney_bottom_mask.png', px = 71, py = 95 })

SMODS.Sound({key = "bad_to_the_bone", path = "bad_to_the_bone.ogg"})

local jokerInfo = {
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
	perishable = true,
	fanwork = 'iron'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_shaft", set = "Other"}
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_mod }}
end

function jokerInfo.update(self, card, dt)
    if not card.config.center.discovered then
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
        local atlas = G.ASSET_ATLAS[card.config.center.atlas]
        card.config.center.atlas = 'fnwk_iron_boney'
        card.children.boned = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas, card.config.center.pos)
        card.config.center.pos = { x = 0, y = 0}
        card.children.boned:set_role(role)
        card.children.boned.custom_draw = true
        card.children.backing = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['fnwk_iron_boney'], {x = 1, y = 0})
        card.children.backing:set_role(role)
        card.children.backing.custom_draw = true

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
                if card.children.boned then card.children.boned:remove() end
                card.children.boned = nil
                if card.children.backing then card.children.backing:remove() end
                card.children.backing = nil

                -- reset this card's base values
                card.ability.mask_mod = 0
                card.ability.mask_target = 0
                card.ability.boned = true
                card.config.center.atlas = 'fnwk_iron_boney'
                card.config.center.pos = { x = 0, y = 0}
                card.config.center.custom_draw = false

                -- bad to the bone
                card:set_sprites(card.config.center)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_boney'), colour = G.C.DARK_EDITION, sound = 'fnwk_bad_to_the_bone', delay = 1.3, no_juice = true})
                card:juice_up(1.4)
                G.ROOM.jiggle = G.ROOM.jiggle + 6
                return true    
            end 
        }))
    end
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and not card.debuff and card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end

    if context.blueprint then
        return
    end
    
    if context.cardarea == G.jokers and context.joker_destroyed and context.removed == card and not card.debuff then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function() 
                local rand_set = {}
                for i=1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card then
                        rand_set[#rand_set+1] = i
                    end
                end
                
                if #rand_set == 0 then
                    return true
                end
             
                local rand_idx = pseudorandom_element(rand_set, pseudoseed('boney'))
                local rand_joker = G.jokers.cards[rand_idx]

                -- immediately replace with boney, forgoing any animation
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                local new_joker = create_card('Joker', G.jokers, nil, 2, true, nil, 'j_fnwk_iron_boney', 'bon')

                -- set boney's new abilities
                new_joker:add_to_deck()
                new_joker:hard_set_T(rand_joker.T.x, rand_joker.T.y, rand_joker.T.w, rand_joker.T.h)
                new_joker.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
                new_joker.ability.boned = false
                new_joker.config.center.atlas = rand_joker.config.center.atlas
                new_joker.config.center.pos = rand_joker.config.center.pos
                new_joker.config.center.custom_draw = true
                new_joker:set_sprites(new_joker.config.center)

                -- place boney
                G.jokers:emplace(new_joker, nil, nil, nil, nil, rand_idx)
                rand_joker:remove()
                G.GAME.joker_buffer = 0
                return true 
            end 
        }))
        
	end
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered then
        return
    end
    
    if card.ability.boned then
        return
    end

    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)


    G.SHADERS['fnwk_boney_bottom']:send('mask_tex', G.ASSET_ATLAS['fnwk_boney_bottom_mask'].image)
    G.SHADERS['fnwk_boney_bottom']:send('mask_mod', 0)
    G.SHADERS['fnwk_boney_bottom']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_boney_bottom']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_boney_bottom']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_boney_bottom'], G.SHADERS['fnwk_boney_bottom'])
    card.children.backing:draw_self()

    G.SHADERS['fnwk_boney_bottom']:send('mask_mod', card.ability.mask_mod)
    card.children.center:draw_self()

    -- top effect values
    G.SHADERS['fnwk_boney_top']:send('mask_tex', G.ASSET_ATLAS['fnwk_boney_top_mask'].image)
    G.SHADERS['fnwk_boney_top']:send('stencil', G.ASSET_ATLAS['fnwk_boney_stencil'].image)
    G.SHADERS['fnwk_boney_top']:send('mask_mod', 1)
    G.SHADERS['fnwk_boney_top']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_boney_top']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_boney_top']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_boney_top'], G.SHADERS['fnwk_boney_top'])

    -- drawing and clearing
    card.children.boned:draw_self()
    love.graphics.setStencilTest()
    love.graphics.setShader()


end

return jokerInfo