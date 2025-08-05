local timer_mod = 2
G.TIMERS.FNWK_CRYSTAL_REAL = 0

local ref_game_update = Game.update
function Game:update(dt)
    G.TIMERS.FNWK_CRYSTAL_REAL = G.TIMERS.FNWK_CRYSTAL_REAL + dt * timer_mod
    return ref_game_update(self, dt)
end

local voucherInfo = {
    name = 'Waystone',
    config = {
        extra = {}
    },
    cost = 10,
    requires = {'v_fnwk_streetlight_waystone'},
    unlocked = false,
    unlock_condition = { type = 'ante_up', ante_count = 4 },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist  = 'leafy',
}

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = {self.unlock_condition.ante_count}}
end

function voucherInfo.check_for_unlock(self, args)
    if not G.jokers or args.type ~= self.unlock_condition.type or not G.GAME.fnwk_waystone_ante then
        return false
    end
    
    return args.ante >= G.GAME.fnwk_waystone_ante
end

function voucherInfo.calculate(self, card, context)
    if not (context.end_of_round and context.game_over) or card.ability.extra.used then
        return
    end
    
    card.ability.extra.used = true

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blocking = false,
        func = function()
            G.FUNCS.wipe_on(nil, true, 1.25, G.C.BLACK)
            return true
        end
    }))

    local old_music_vol = G.SETTINGS.SOUND.music_volume
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.25,
        blocking = false,
        func = function()
            if G.screenwipe then
                G.screenwipe.children.particles:remove()
                G.screenwipe:remove()
                G.screenwipe.children.particles = nil
                G.screenwipe = nil
                G.screenwipecard = nil
            end

            ease_value(G.SETTINGS.SOUND, 'music_volume', -G.SETTINGS.SOUND.music_volume, nil, nil, nil, 0.15)

            G.HUD.states.visible = false
            G.jokers.states.visible = false
            G.consumeables.states.visible = false
            G.deck.states.visible = false
            G.HUD_blind.states.visible = false
            G.hand.states.visible = false

            G.GAME.round_resets.ante = G.GAME.fnwk_waystone_ante or 1

            local old_joker_count = #G.jokers.cards
            for i = #G.jokers.cards,1, -1 do
                local c = G.jokers:remove_card(G.jokers.cards[i])
                c:remove()
                c = nil
            end

            for i=1, old_joker_count do
                SMODS.add_card({set = 'Joker', area = G.jokers, no_edition = true, key_append = 'fnwk_binding'})
            end

            local old_consumable_count = #G.consumeables.cards
            for i = #G.consumeables.cards,1, -1 do
                local c = G.consumeables:remove_card(G.consumeables.cards[i])
                c:remove()
                c = nil
            end

            for i=1, old_consumable_count do
                SMODS.add_card({set = 'Consumeables', area = G.consumeables, key_append = 'fnwk_binding'})
            end

            G.TIMERS.FNWK_CRYSTAL_REAL = 0
            --Prep the splash screen shaders for both the background(colour swirl) and the foreground(white flash), starting at black
            G.SPLASH_BACK = Sprite(-30, -13, G.ROOM.T.w+60, G.ROOM.T.h+22, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
            G.SPLASH_BACK:define_draw_steps({{
                shader = 'splash',
                send = {
                    {name = 'time', ref_table = G.TIMERS, ref_value = 'FNWK_CRYSTAL_REAL'},
                    {name = 'vort_speed', val = 1},
                    {name = 'colour_1', ref_table = G.C, ref_value = 'CRYSTAL'},
                    {name = 'colour_2', ref_table = G.C, ref_value = 'WHITE'},
                    {name = 'mid_flash', val = 0},
                    {name = 'vort_offset', val = (2*90.15315131*os.time())%100000},
                }}})
            G.SPLASH_BACK:set_alignment({
                major = G.ROOM_ATTACH,
                type = 'cm',
                offset = {x=0,y=0}
            })

            G.SPLASH_FRONT = Sprite(0,-20, G.ROOM.T.w*2, G.ROOM.T.h*4, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
            G.SPLASH_FRONT:define_draw_steps({{
                shader = 'flash',
                send = {
                    {name = 'time', ref_table = G.TIMERS, ref_value = 'FNWK_CRYSTAL_REAL'},
                    {name = 'mid_flash', val = 1}
                }}})
            G.SPLASH_FRONT:set_alignment({
                major = G.ROOM_ATTACH,
                type = 'cm',
                offset = {x=0,y=0}
            })

            local waystone = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    waystone = Card(
                        G.ROOM.T.w/2 - 1.2*G.CARD_W/2,
                        10 + G.ROOM.T.h/2 - 1.2*G.CARD_H/2,
                        1.2*G.CARD_W,
                        1.2*G.CARD_H,
                        G.P_CARDS.empty,
                        G.P_CENTERS['v_fnwk_streetlight_binding']
                    )
                    waystone.T.y = G.ROOM.T.h/2 - 1.2*G.CARD_H/2
                    waystone.ambient_tilt = 1
                    waystone.states.drag.can = false
                    waystone.states.hover.can = false
                    waystone.no_ui = true
                    G.VIBRATION = G.VIBRATION + 2
                    play_sound('whoosh1', 0.7, 0.2)
                    play_sound('introPad1', 1.4, 0.6)
                    return true 
                end
            }))

            --dissolve fool card and start to fade in the vortex
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1.8,
                func = function()
                    waystone:start_dissolve({G.C.WHITE, G.C.WHITE},true, 12, true)
                    play_sound('splash_buildup', 2, 1)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 12,
                func = function()
                    G.HUD.states.visible = true
                    G.jokers.states.visible = true
                    G.consumeables.states.visible = true
                    G.deck.states.visible = true
                    G.HUD_blind.states.visible = true
                    G.hand.states.visible = true

                    if G.SPLASH_FRONT then G.SPLASH_FRONT:remove(); G.SPLASH_FRONT = nil end
                    if G.SPLASH_BACK then G.SPLASH_BACK:remove(); G.SPLASH_BACK = nil end

                    G.SPLASH_BACK = Sprite(-30, -13, G.ROOM.T.w+60, G.ROOM.T.h+22, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
                    G.SPLASH_BACK:set_alignment({
                        major = G.play,
                        type = 'cm',
                        bond = 'Strong',
                        offset = {x=0,y=0}
                    })

                    G.ARGS.spin = {
                        amount = 0,
                        real = 0,
                        eased = 0
                    }
                    
                    local splash_args = {mid_flash = 1.6}
                    ease_value(splash_args, 'mid_flash', -1.6, nil, nil, nil, 4)
                    
                    G.SPLASH_BACK:define_draw_steps({{
                        shader = 'fnwk_mod_background',
                        send = {
                            {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
                            {name = 'spin_time', ref_table = G.TIMERS, ref_value = 'BACKGROUND'},
                            {name = 'colour_1', ref_table = G.C.BACKGROUND, ref_value = 'C'},
                            {name = 'colour_2', ref_table = G.C.BACKGROUND, ref_value = 'L'},
                            {name = 'colour_3', ref_table = G.C.BACKGROUND, ref_value = 'D'},
                            {name = 'contrast', ref_table = G.C.BACKGROUND, ref_value = 'contrast'},
                            {name = 'spin_amount', ref_table = G.ARGS.spin, ref_value = 'amount'},
                            {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
                        }}})

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1,
                        func = function()
                            play_sound('whoosh1', math.random()*0.1 + 0.3,0.3)
                            play_sound('crumple'..math.random(1,5), math.random()*0.2 + 0.6,0.65)
                            G.VIBRATION = G.VIBRATION + 1
                            return true
                        end
                    }))

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 3.6,
                        func = (function()
                            play_sound('magic_crumple2', 1)
                            play_sound('whoosh1', 0.8, 0.8)
                            G.VIBRATION = G.VIBRATION + 1.5

                            ease_value(G.SETTINGS.SOUND, 'music_volume', old_music_vol)
                            return true
                    end)}))
                    return true
                end
            }))
            return true
        end
    }))

    return {
        saved = 'k_crystal'
    }
end

return voucherInfo