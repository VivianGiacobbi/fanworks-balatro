

local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

-- this is functionally a recreation of the old "main.lua" function in LuaNES
assert(SMODS.load_file('includes/LuaNES/nes.lua'))()
local emu = {
    -- flag for when the NES is running
    running = false,
    startup = false,
    startup_time = 0,
    control_card = nil,

    game = {
        id = 'none',
        run_state = 'none',
        game_state = 'none',
        timers = {},
        start_pos = nil
    },

    -- input events and queueing, can be changed from the joker calc
    input = {
        events = {},
        inputs = {
            [Pad.A] = 'x',
            [Pad.B] = 'z',
            [Pad.START] = 'return',
            [Pad.UP] = 'up',
            [Pad.DOWN] = 'down',
            [Pad.LEFT] = 'left',
            [Pad.RIGHT] = 'right',
        }
    },
    
    -- frame data to render, expects NTSC framerate
    frames = {
        waiting = 0,
        fps = 59.94,
    },

    -- image the video output is rendered to
    init_video = function(self, width, height)
        if not width then width = PPU.SCREEN_WIDTH end
        if not height then height = PPU.SCREEN_HEIGHT end

        local image_data = love.image.newImageData(width + 1, height + 1)
        self.video = {
            res = {
                width = width,
                height = height
            },
            image_data = image_data,
            image = love.graphics.newImage(image_data),
        }
    end,

    -- sets up audio roughly equal to the NES's mono sound samples
    audio = {},
    init_audio = function(self, samplerate, bits, channels)
        
        if not samplerate then samplerate = 44100 end
        if not bits then bits = 16 end
        if not channels then channels = 1 end

        self.audio = {
            sound = love.sound.newSoundData(samplerate / 60 + 1, samplerate, bits, 1),
            QS = love.audio.newQueueableSource(samplerate, bits, 1),
        }
    end,

    start_nes = function(self, game_str, control_card, start_pos)
        if self.running then
            self:stop_nes()
        end
        local start_args = {
            file = mod.path .. 'includes/LuaNES/roms/'..game_str..'.nes',
            loglevel = 0,
            pc = nil,
            palette = UTILS.map(
                    PALETTE:defacto_palette(),
                    function(c)
                        return {c[1] / 256, c[2] / 256, c[3] / 256}
                    end
            )
        }

        self.nes = NES:new(start_args)
        self.nes:reset()
        self.audio.QS:setVolume(0.5)
        self.game.id = game_str
        self.game.timers.startup_timer = {
            timer_limit = 1,
            subtimers = 4,
            delay = 0.1,
        }
        self.control_card = control_card
        self.game.start_pos = start_pos
        self.game.run_state = 'startup'
        G.EMULATOR_RUNNING = true
        self.running = true
    end,

    stop_nes = function(self)
        self.game.timers = {}
        self.game.run_state = 'none'
        self.game.game_state = 'none'
        self.control_card = nil
        self.game.id = 'none'
        self.running = false
        self.nes = nil
        G.EMULATOR_RUNNING = false
    end
}


-- bindings for love to embed inpit
local ref_key_pressed = love.keypressed
function love.keypressed(key)

    if emu.running or emu.pressed then
        for k, v in pairs(emu.input.inputs) do
            if v == key then
                emu.input.events[#emu.input.events + 1] = {"keydown", k}
            end
        end
        emu.pressed = true
    end

    ref_key_pressed(key)
end

local ref_key_released = love.keyreleased
function love.keyreleased(key)
    if emu.running or emu.released then
        for k, v in pairs(emu.input.inputs) do
            if v == key then
                emu.input.events[#emu.input.events + 1] = {"keyup", k}
            end
        end
        emu.released = true
    end

    ref_key_released(key)
end

local cabinet_overlay = love.graphics.newImage(mod_path..'assets/1x/cabinet_man.png')

local ref_draw = love.draw
function love.draw()
    if not emu.running or not emu.video or emu.drawn then
        ref_draw()
        return
    end

    love.graphics.setColor(1,1,1,1)

    local width = emu.video.res.width
    local height = emu.video.res.height
    for i=1, width * height do
        local x = (i - 1) % width
        local y = math.floor((i - 1) / width) % height
        local px = emu.nes.cpu.ppu.output_pixels[i]
        emu.video.image_data:setPixel(x + 1, y + 1, px[1], px[2], px[3], 1)
    end
    emu.video.image:replacePixels(emu.video.image_data)
    ref_draw()

    love.graphics.setColor(1,1,1,1)

    local screen_res = { x = love.graphics.getWidth(), y = love.graphics.getHeight() }
    local scale = screen_res.y * 0.75 / width
    local in_x_pos = screen_res.x / 2 - width * scale / 2
    local in_y_pos = screen_res.y / 2 - height * scale / 2
    local out_x_pos = screen_res.x / 2 - cabinet_overlay:getPixelWidth() * scale / 2
    local out_y_pos = screen_res.y / 2 - cabinet_overlay:getPixelHeight() * scale / 2

    if emu.game.timers.startup_timer and emu.game.timers.startup_timer.time > 0 then
        local max_lerp = (emu.game.timers.startup_timer.sub_count + 1) / emu.game.timers.startup_timer.subtimers
        local lerp_val = emu.game.timers.startup_timer.sub_time /  emu.game.timers.startup_timer.sub_limit * max_lerp
        in_x_pos = math.lerp(emu.game.start_pos.x, in_x_pos, lerp_val)
        in_y_pos = math.lerp(emu.game.start_pos.y, in_y_pos, lerp_val)
        out_x_pos = math.lerp(emu.game.start_pos.x, out_x_pos, lerp_val)
        out_y_pos = math.lerp(emu.game.start_pos.y, out_y_pos, lerp_val)
        scale = math.lerp(0, scale, lerp_val)
    end

    love.graphics.draw(
        emu.video.image,
        in_x_pos,
        in_y_pos,
        0,
        scale,
        scale
    )
    love.graphics.draw(
        cabinet_overlay,
        out_x_pos,
        out_y_pos,
        0,
        scale,
        scale
    )
    emu.drawn = true
end

local jokerInfo = {
    name = "Cabinet Man",
    config = {},
    rarity = 3,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    fanwork = 'streetlight',
}



function jokerInfo.add_to_deck(self, card, from_debuff)
    if G.EMULATOR_RUNNING then
        return
    end

    G.FUNCS:exit_overlay_menu()
    G.SETTINGS.SOUND.music_volume = 0
    G.SETTINGS.SOUND.game_sounds_volume = 100
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_cabinet_start'), colour = G.C.MONEY, delay = 0.8})
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            G.CONTROLLER.locks.frame = true
            emu:init_video()
            emu:init_audio()
        
            local center = card.children.center
            local scale = G.TILESCALE * G.TILESIZE
            local x_pos = (center.VT.x + center.VT.w / 2) * scale + (center.VT.w * center.VT.scale / 2) * scale
            local y_pos = (center.VT.y + center.VT.h / 2) * scale + (center.VT.h * center.VT.scale / 2) * scale
            local start_pos = {
                x = x_pos,
                y = y_pos,
            }
            
            emu:start_nes('dk', card, start_pos)
            return true 
        end 
    }))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if emu.running then
        emu:stop_nes()
    end
end

function jokerInfo.update(self, card, dt)
    if not emu.running or emu.control_card ~= card then
        return 
    end

    -- track state timers
    for k, v in pairs(emu.game.timers) do
        if not v.time then
            v.time = 0
            if v.subtimers then
                -- used to alternate between the timer and delay
                v.sub_count = 0
                v.delay_count = 0

                v.sub_time = 0
                v.delay_time = 0
                v.sub_limit = v.timer_limit / (v.subtimers > 0 and v.subtimers or 1)
            end
        end

        if v.time < v.timer_limit then
            if v.sub_time then
                -- increment sub-timer up to the sub limit
                if v.sub_count == v.delay_count then
                    v.sub_time = v.sub_time + dt
                    v.time = v.time + dt
                    if v.sub_time >= v.sub_limit then
                        v.sub_time = 0
                        v.sub_count = v.sub_count + 1
                    end 
                -- or use the sub timer to increment the delay
                elseif v.sub_count > v.delay_count then
                    v.delay_time = v.delay_time + dt
                    if v.delay_time >= v.delay then
                        v.delay_time = 0
                        v.delay_count = v.delay_count + 1
                    end
                end
            else
                v.time = v.time + dt
            end
            
            if v.time >= v.timer_limit then 
                if k == 'startup_timer' then
                    emu.game.run_state = 'run'
                end
                emu.game.timers[k] = nil
            end
        end
    end

    if emu.game.run_state == 'startup' then
        emu.drawn = nil
        return
    end
    
    emu.frames.waiting = emu.frames.waiting + (dt * emu.frames.fps) / G.SETTINGS.GAMESPEED
    while emu.frames.waiting > 1 do
        for i, v in ipairs(emu.input.events) do
            -- v[1] is the function key, I.E. keyup/keydown
            -- v[2] is the Pad button key, whose value is an integer from 1-7 (excluding select)
            emu.nes.pads[v[1]](emu.nes.pads, 1, v[2])
        end
        emu.input.events = {}
        emu.nes:run_once()
        for i = 1, #emu.nes.cpu.apu.output do
            emu.audio.sound:setSample(i, emu.nes.cpu.apu.output[i])
        end
        emu.audio.QS:queue(emu.audio.sound)
        emu.audio.QS:play()

        emu.frames.waiting = emu.frames.waiting - 1
    end

    emu.pressed = nil
    emu.released = nil
    emu.drawn = nil

    if emu.game.run_state == 'shutdown' then
        return
    end
    
    -- individual win states for games
    if emu.game.id == 'dk' then
        -- forces demo to never start
        emu.nes.cpu.ram[0X0044] = 0
        emu.nes.cpu.ram[0x0058] = 0

        -- level state (1 is stage 1, is stage 3, 0 is title)
        if emu.nes.cpu.ram[0x0053] == 3 then
            emu.game.game_state = 'win'
        end
        if emu.nes.cpu.ram[0x0400] == 1 and emu.nes.cpu.ram[0x0096] == 255 then
            emu.game.game_state = 'lose'
        end
        
    end
       
    if emu.game.id == 'dl' then

    end

    if emu.game.id == 'tmnt' then

    end

    if emu.game.game_state == 'win' or emu.game.game_state == 'lose' then
        emu.game.run_state = 'shutdown'
    end

    if emu.game.game_state == 'win' or emu.game.game_state == 'lose' then
        local finish_state = 'k_cabinet_'..emu.game.game_state
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = emu.game.game_state == 'win' and 5 or 8,
            func = function()
                G.CONTROLLER.locks.frame = nil
                G.CONTROLLER.locks.frame_set = nil
                    emu:stop_nes()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(finish_state), colour = G.C.MONEY, delay = 0.8})
                return true 
            end 
        }))
        if emu.game.game_state == 'win' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    local newJoker = create_card('Joker', G.jokers, nil, 2, true, nil, 'j_fnwk_streetlight_indulgent', 'rif')
                    newJoker:add_to_deck()
                    G.jokers:emplace(newJoker)
                    newJoker:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true 
                end 
            }))
        end

        emu.game.game_state = 'none'
    end
end

return jokerInfo