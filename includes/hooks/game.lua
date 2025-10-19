local ref_game_menu = Game.main_menu
function Game:main_menu(change_context, ...)
    local ret = ref_game_menu(self, change_context, ...)

    if JoJoFanworks.config['enable_Title'] then
        G.FNWK_TITLE_SUB = Sprite(0, 0, 13, 13*(G.ASSET_ATLAS['fnwk_title_sub'].py/G.ASSET_ATLAS['fnwk_title_sub'].px), G.ASSET_ATLAS['fnwk_title_sub'], {x=0,y=0})

        G.FNWK_TITLE_SUB:set_alignment({
            major = G.title_top,
            type = 'cm',
            bond = 'Strong',
            offset = {x=0,y=0}
        })

        G.FNWK_TITLE_SUB:define_draw_steps({{
            shader = 'fnwk_title_sub',
            send = {
                {name = 'dissolve', ref_table = G.FNWK_TITLE_SUB, ref_value = 'dissolve'},
                {name = 'time', val = 123.33412*12.5123152%3000},
                {name = 'texture_details', val = G.FNWK_TITLE_SUB:get_pos_pixel()},
                {name = 'image_details', val = G.FNWK_TITLE_SUB:get_image_dims()},
                {name = 'burn_colour_1', val = G.C.WHITE},
                {name = 'burn_colour_2', val = G.C.WHITE},
                {name = 'shadow', ref_table = G.FNWK_TITLE_SUB, ref_value = 'fake_shadow_val'},
                {name = 'main_color', ref_table = SMODS.Gradients, ref_value = 'fnwk_blind_rainbow_light'},
            }
        }})

        G.FNWK_TITLE_SUB.fake_shadow_val = false
        G.FNWK_TITLE_SUB.dissolve_colours = {G.C.WHITE, G.C.WHITE}
        G.FNWK_TITLE_SUB.dissolve = 1

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = change_context == 'splash' and 1.8 or change_context == 'game' and 2 or 0.5,
            blockable = false,
            blocking = false,
            func = function()
                ease_value(G.FNWK_TITLE_SUB, 'dissolve', -1, nil, nil, nil, change_context == 'splash' and 2.3 or 0.9)
                return true
            end
        }))
    end
    
    G.NEON_FLASH = Sprite(0,0, G.ROOM.T.w*2, G.ROOM.T.h*4, G.ASSET_ATLAS['fnwk_screen'], {x = 0, y = 0})
    G.NEON_VALS = { AMT = 0, MAX = 1000 }
    G.NEON_FLASH:define_draw_steps({{
    	shader = 'fnwk_neon_flash',
    	send = {
    		{name = 'flash', ref_table = G.NEON_VALS, ref_value = 'AMT'},
            {name = 'flash_max', ref_table = G.NEON_VALS, ref_value = 'MAX'},
    	}}})
    G.NEON_FLASH:set_alignment({
        major = G.ROOM_ATTACH,
    	type = 'cm',
    	offset = {x=0,y=0}
    })

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = change_context == 'splash' and 1.8 or change_context == 'game' and 2 or 0.5,
        blockable = false,
        blocking = false,
        func = function()
            G.fnwk_splash = {
                value = 0,
                duration = 2,
                direction = 1,
                min_scale = 0.45,
                max_scale = 0.53
            }
            local rand_quote = G.localization.misc.quips.splash[math.random(1, #G.localization.misc.quips.splash)]
            local dyna_obj = DynaText({
                string = {rand_quote},
                colours = {G.C.YELLOW},
                pop_in = 0.1,
                pop_in_rate = 99999999,
                scale_function = function()
                    if G.fnwk_splash.direction > 0 then
                        G.fnwk_splash.value = G.fnwk_splash.value + G.real_dt
                        if G.fnwk_splash.value >= G.fnwk_splash.duration then
                            G.fnwk_splash.direction = -1
                        end
                    else
                        G.fnwk_splash.value = G.fnwk_splash.value - G.real_dt
                        if G.fnwk_splash.value <= 0 then
                            G.fnwk_splash.direction = 1
                        end
                    end
                    
                    local lerp = ArrowAPI.math.ease_funcs.in_out_sin(G.fnwk_splash.value)
                    return lerp * (G.fnwk_splash.max_scale - G.fnwk_splash.min_scale) + G.fnwk_splash.min_scale
                end,
                shadow = true,
                float = true,
            })
            local splash_ui = UIBox({
                definition = {
                    n = G.UIT.ROOT,
                    config = {align = "cm", colour = G.C.CLEAR},
                    nodes = {{
                        n = G.UIT.O,
                        func = 'fnwk_splash_update',
                        config = {
                            align = 'cm',
                            object = dyna_obj
                        }
                    }}
                },
                config = { align = 'cm', offset = {x = -4.75, y = 0.75} ,
                major = G.title_top,
                bond = 'Weak'}
            })
            splash_ui.T.r = math.pi/12
            splash_ui.VT.r = math.pi/12
            return true
        end
    }))

    return ret
end

G.FUNCS.fnwk_splash_update = function(e)
    e:update_object()
end

local ref_game_delete = Game.delete_run
function Game:delete_run(...)
    G.in_delete_run = true
    if self.ROOM then
        if self.FNWK_TITLE_SUB then self.FNWK_TITLE_SUB:remove(); self.FNWK_TITLE_SUB = nil end
        if self.NEON_FLASH then self.NEON_FLASH:remove() self.NEON_FLASH = nil end
    end

    return ref_game_delete(self, ...)
end

local ref_game_update_go = Game.update_game_over
function Game:update_game_over(dt)
    local check_loss = false
    if not G.STATE_COMPLETE then check_loss = true end

    local ret = ref_game_update_go(self, delay)

    if G.STATE_COMPLETE and check_loss then check_for_unlock({type = 'fnwk_run_loss'}) end
    return ret
end