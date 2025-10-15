SMODS.Atlas({ key = 'cabinet_overlay', path = 'cabinet_man.png', px = 320, py = 378 })
SMODS.Atlas({ key = 'cabinet_shadow', path = 'cabinet_man_shadow.png', px = 320, py = 378 })
SMODS.Atlas({ key = 'cabinet_joystick', path = 'cabinet_man_joystick.png', px = 41, py = 41 })
SMODS.Atlas({ key = 'cabinet_button_left', path = 'cabinet_button_left.png', px = 25, py = 14 })
SMODS.Atlas({ key = 'cabinet_button_right', path = 'cabinet_button_right.png', px = 25, py = 14 })
SMODS.Atlas({ key = 'cabinet_button_up', path = 'cabinet_button_up.png', px = 25, py = 14 })
SMODS.Atlas({ key = 'cabinet_button_down', path = 'cabinet_button_down.png', px = 25, py = 14 })

local joy_poses = {
    ['up'] = 1,
    ['right'] = 3,
    ['down'] = 5,
    ['left'] = 7,
}

local button_maps = {
    ['x'] = 'right',
    ['z'] = 'down',
    ['rshift'] = 'left',
    ['return'] = 'up',
}

-- this is functionally a recreation of the old "main.lua" function in LuaNES
assert(SMODS.load_file('includes/LuaNES/nes.lua'))()
G.EMU = {
    -- flag for when the NES is running
    running = false,
    startup = false,
    startup_time = 0,
    control_card = nil,

    anim_states = {},

    last_joy_pos = 0,
    joy_quad = nil,
    button_up_quad = nil,
    button_down_quad = nil,
    button_right_quad = nil,
    button_left_quad = nil,

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
            ['x'] = Pad.A,
            ['z'] = Pad.B,
            ['return'] = Pad.START,
            ['rshift'] = Pad.SELECT,
            ['up'] = Pad.UP,
            ['down'] = Pad.DOWN,
            ['left'] = Pad.LEFT,
            ['right'] = Pad.RIGHT,
        }
    },
    
    -- frame data to renders, expects NTSC framerate
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
    init_audio = function(self, samplerate, bits, channels, framerate)
        
        if not samplerate then samplerate = 44100 end
        if not bits then bits = 16 end
        if not channels then channels = 1 end

        self.audio = {
            sound = love.sound.newSoundData(samplerate / (framerate or 60) + 1, samplerate, bits, 1),
            QS = love.audio.newQueueableSource(samplerate, bits, 1),
        }
    end,

    start_nes = function(self, game_str, control_card, framerate, start_pos)
        if self.running then
            self:stop_nes()
        end
        local start_args = {
            file = JoJoFanworks.path .. 'includes/LuaNES/roms/'..game_str..'.nes',
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
            time = 0,
            timer_limit = 0.12,
            subtimers = 4,
            delay = 0.1,
        }
        self.control_card = control_card
        self.frames.fps = framerate or 59.94
        self.game.start_pos = start_pos
        self.game.run_state = 'startup'

        local joy_atlas = G.ASSET_ATLAS['fnwk_cabinet_joystick']
        G.EMU.joy_quad = love.graphics.newQuad(0, 0, joy_atlas.px, joy_atlas.py, joy_atlas.image:getDimensions())

        local up_atlas = G.ASSET_ATLAS['fnwk_cabinet_button_up']
        G.EMU.button_up_quad = love.graphics.newQuad(0, 0, up_atlas.px, up_atlas.py, up_atlas.image:getDimensions())

        local down_atlas = G.ASSET_ATLAS['fnwk_cabinet_button_down']
        G.EMU.button_down_quad = love.graphics.newQuad(0, 0, down_atlas.px, down_atlas.py, down_atlas.image:getDimensions())

        local left_atlas = G.ASSET_ATLAS['fnwk_cabinet_button_left']
        G.EMU.button_left_quad = love.graphics.newQuad(0, 0, left_atlas.px, left_atlas.py, left_atlas.image:getDimensions())

        local right_atlas = G.ASSET_ATLAS['fnwk_cabinet_button_right']
        G.EMU.button_right_quad = love.graphics.newQuad(0, 0, right_atlas.px, right_atlas.py, right_atlas.image:getDimensions())

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

-- bindings for love to embed input
local ref_key_pressed = love.keypressed
function love.keypressed(key)
    if G.EMU.running then
        if key == 'escape' then
            G.EMU.esc_pressed = true
        end

        if G.EMU.input.inputs[key] then
            G.EMU.input.events[#G.EMU.input.events + 1] = {"keydown", G.EMU.input.inputs[key]}
            local last_state = G.EMU.anim_states[key]
            if not last_state then
                G.EMU.anim_states[key] = true
                if button_maps[key] then
                    local atlas = G.ASSET_ATLAS['fnwk_cabinet_button_'..button_maps[key]]
                    G.EMU['button_'..button_maps[key]..'_quad'] = love.graphics.newQuad(
                        atlas.px,
                        0,
                        atlas.px,
                        atlas.py,
                        atlas.image:getDimensions()
                    )
                end
            end

            local joy_pos = 0
            local count = 0
            for k, v in pairs(joy_poses) do
                if G.EMU.anim_states[k]
                and not (k == 'up' and G.EMU.anim_states['down'])
                and not (k == 'down' and G.EMU.anim_states['up'])
                and not (k == 'left' and G.EMU.anim_states['right'])
                and not (k == 'right' and G.EMU.anim_states['left']) then
                    count = count + 1
                    joy_pos = joy_pos + v
                end
            end
            if count == 2 then
                if G.EMU.anim_states['up'] and G.EMU.anim_states['left'] then
                    joy_pos = 8
                else
                    joy_pos = joy_pos/2
                end
            end

            if joy_pos ~= G.EMU.last_joy_pos then
                local atlas = G.ASSET_ATLAS['fnwk_cabinet_joystick']
                G.EMU.joy_quad = love.graphics.newQuad(
                    joy_pos*atlas.px,
                    0,
                    atlas.px,
                    atlas.py,
                    atlas.image:getDimensions()
                )
            end

            G.EMU.last_joy_pos = joy_pos
        end
    end

    ref_key_pressed(key)
end

local ref_key_released = love.keyreleased
function love.keyreleased(key)
    if G.EMU.running then
        if key == 'escape' then
            G.EMU.esc_pressed = nil
        end

        if G.EMU.input.inputs[key] then
            G.EMU.input.events[#G.EMU.input.events + 1] = {"keyup", G.EMU.input.inputs[key]}
            local last_state = G.EMU.anim_states[key]
            if last_state then
                G.EMU.anim_states[key] = nil
                if button_maps[key] then
                    local atlas = G.ASSET_ATLAS['fnwk_cabinet_button_'..button_maps[key]]
                    G.EMU['button_'..button_maps[key]..'_quad'] = love.graphics.newQuad(
                        0,
                        0,
                        atlas.px,
                        atlas.py,
                        atlas.image:getDimensions()
                    )
                end
            end

            local joy_pos = 0
            local count = 0
            for k, v in pairs(joy_poses) do
                if G.EMU.anim_states[k]
                and not (k == 'up' and G.EMU.anim_states['down'])
                and not (k == 'down' and G.EMU.anim_states['up'])
                and not (k == 'left' and G.EMU.anim_states['right'])
                and not (k == 'right' and G.EMU.anim_states['left']) then
                    count = count + 1
                    joy_pos = joy_pos + v
                end
            end
            if count == 2 then
                if G.EMU.anim_states['up'] and G.EMU.anim_states['left'] then
                    joy_pos = 8
                else
                    joy_pos = joy_pos/2
                end
            end

            if joy_pos ~= G.EMU.last_joy_pos then
                local atlas = G.ASSET_ATLAS['fnwk_cabinet_joystick']
                G.EMU.joy_quad = love.graphics.newQuad(
                    joy_pos*atlas.px,
                    0,
                    atlas.px,
                    atlas.py,
                    atlas.image:getDimensions()
                )
                G.EMU.last_joy_pos = joy_pos
            end
        end
    end

    ref_key_released(key)
end

local ref_update = love.update
function love.update(dt)
    local mod_dt = G.real_dt and G.real_dt or dt

    if G.EMU.running then
        -- track state timers
        for k, v in pairs(G.EMU.game.timers) do
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
                        v.sub_time = v.sub_time + mod_dt
                        v.time = v.time + mod_dt
                        if v.sub_time >= v.sub_limit then
                            v.sub_time = 0
                            v.sub_count = v.sub_count + 1
                        end 
                    -- or use the sub timer to increment the delay
                    elseif v.sub_count > v.delay_count then
                        v.delay_time = v.delay_time + mod_dt
                        if v.delay_time >= v.delay then
                            v.delay_time = 0
                            v.delay_count = v.delay_count + 1
                        end
                    end
                else
                    v.time = v.time + mod_dt
                end
                
                if v.time >= v.timer_limit then 
                    if k == 'startup_timer' then
                        G.EMU.game.run_state = 'run'
                    end
                    G.EMU.game.timers[k] = nil
                end
            end
        end

        if G.EMU.game.run_state == 'startup' then
            G.EMU.drawn = nil
            return
        end
        
        G.EMU.frames.waiting = G.EMU.frames.waiting + (mod_dt * G.EMU.frames.fps)
        while G.EMU.frames.waiting > 1 do
            if G.EMU.game.run_state == 'shutdown' then
                for _, v in ipairs(G.EMU.input.events) do
                    G.EMU.nes.pads.pads[1]:reset()
                end
            else
                for _, v in ipairs(G.EMU.input.events) do
                    -- v[1] is the function key, I.E. keyup/keydown
                    -- v[2] is the Pad button key, whose value is an integer from 1-7 (excluding select)
                    G.EMU.nes.pads[v[1]](G.EMU.nes.pads, 1, v[2])
                end
            end
            G.EMU.input.events = {}
            G.EMU.nes:run_once()
            for i = 1, #G.EMU.nes.cpu.apu.output do
                G.EMU.audio.sound:setSample(i, G.EMU.nes.cpu.apu.output[i])
            end
            G.EMU.audio.QS:queue(G.EMU.audio.sound)
            G.EMU.audio.QS:play()

            G.EMU.frames.waiting = G.EMU.frames.waiting - 1
        end

        G.EMU.drawn = nil
    end
    
    ref_update(dt)
end