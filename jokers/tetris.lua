local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end
------------------------------Set up emulator
local oldRequire = require
require = function(path)
    if path == 'table.clear' then return end
    return assert(SMODS.load_file('jokers/LuaNES/'..path..'.lua'))()
end

require('nes')
mod.nesData = {}
mod.nesData.width = 256
mod.nesData.height = 240
mod.nesData.imageData = love.image.newImageData(mod.nesData.width + 1, mod.nesData.height + 1)
mod.nesData.image = love.graphics.newImage(mod.nesData.imageData)
local samplerate = 44100
local bits = 16
local channels = 1
mod.nesData.sound = love.sound.newSoundData(samplerate / 60 + 1, samplerate, bits, channels)
mod.nesData.QS = love.audio.newQueueableSource(samplerate, bits, channels)
mod.nesData.QS:setVolume(0.5)

mod.nesData.framesToUpdate = 0
mod.nesData.fps = 59.94

mod.nesData.isActive = false
mod.nesData.showFullView = false

mod.nesData.marioScore = 0

function mod.resetMario()
    sendDebugMessage("RESETTING NES")
    mod.nes = NES:new({
        file = mod.path .. 'jokers/LuaNES/roms/Tetris.nes',
        loglevel = 0,
        pc = nil,
        palette = UTILS.map(
                PALETTE:defacto_palette(),
                function(c)
                    return {c[1] / 256, c[2] / 256, c[3] / 256}
                end
        )
    })
    mod.nes:reset()
    mod.nesData.isActive = true
end


--start binding to love

mod.nesData.keyEvents = {}
local keyButtons = {
    ["up"] = Pad.UP,
    ["left"] = Pad.LEFT,
    ["down"] = Pad.DOWN,
    ["right"] = Pad.RIGHT,
    ["x"] = Pad.A,
    ["z"] = Pad.B,
    ["return"] = Pad.START
}


local loveKeyPressedRef = love.keypressed
local loveKeyReleasedRef = love.keyreleased
local loveUpdateRef = love.update
local loveDrawRef = love.draw

function love.keypressed(key)
    for k, v in pairs(keyButtons) do
        if k == key then
            mod.nesData.keyEvents[#mod.nesData.keyEvents + 1] = {"keydown", v}
        end
    end
    loveKeyPressedRef(key)
end

function love.keyreleased(key)
    for k, v in pairs(keyButtons) do
        if k == key then
            mod.nesData.keyEvents[#mod.nesData.keyEvents + 1] = {"keyup", v}
        end
    end
    loveKeyReleasedRef(key)
end

function love.update(dt)


    loveUpdateRef(dt)

    if mod.nesData.isActive then

        while mod.nesData.framesToUpdate > 1 do

            for i, v in ipairs(mod.nesData.keyEvents) do
                mod.nes.pads[v[1]](mod.nes.pads, 1, v[2])
            end

            mod.nesData.keyEvents = {}
            mod.nes:run_once()



            local samples = mod.nes.cpu.apu.output
            for i = 1, #samples do
                mod.nesData.sound:setSample(i, samples[i])
            end
            mod.nesData.QS:queue(mod.nesData.sound)
            mod.nesData.QS:play()

            mod.nesData.framesToUpdate = mod.nesData.framesToUpdate - 1
        end
        local lines = ''
        lines = mod.nes.cpu.ram[0x0050]
        mod.nesData.tetrisLines = tonumber(lines)
        if mod.nes.cpu.ram[0x0776] ~= 0 then
            --no pausing allowed!
            for i=0x07DD,0x07E2 do
                mod.nes.cpu.ram[i] = 0
            end

            for i=0x07F8,0x07FA do
                mod.nes.cpu.ram[i] = 0
            end
        end

        if mod.nes.cpu.ram[0x0770] == 3 then
            for i=0x07DD,0x07E2 do
                mod.nes.cpu.ram[i] = 0
            end
        end
    end
end

function love.draw()
    if mod.nesData.isActive then
        love.graphics.setColor(1,1,1,1)
        local pxs = mod.nes.cpu.ppu.output_pixels

        for i=1,PPU.SCREEN_HEIGHT * PPU.SCREEN_WIDTH do
            local x = (i - 1) % mod.nesData.width
            local y = math.floor((i - 1) / mod.nesData.width) % mod.nesData.height
            local px = pxs[i]
            mod.nesData.imageData:setPixel(x + 1, y + 1, px[1], px[2], px[3], 1)
        end
        mod.nesData.image:replacePixels(mod.nesData.imageData)
    end

    loveDrawRef()
    if mod.nesData.showFullView then
        love.graphics.setColor(1,1,1,0.75)
        love.graphics.draw(mod.nesData.image,0,0,0,1.5,1.5)
    end

end

local jokerInfo = {
    name = "YOU GOT THE TETRIS",
    config = {
        extra = {
            mult = 0
        }
    },
    rarity = 3,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "joel",
}

mod.tetrisCardBase = love.graphics.newImage(mod_path..'assets/1x/jokers/tetris.png')
mod.tetrisCardOverlay = love.graphics.newImage(mod_path..'assets/1x/jokers/tetrisoverlay.png')

local setupCanvas = function(self)
    self.children.center.video = love.graphics.newCanvas(71,95) --why does this work lmaooooooo
    self.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(mod.tetrisCardBase)
    end)
end

jokerInfo.loc_vars = function (self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

jokerInfo.calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        if card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
            }
        end
    end
end

function jokerInfo.update(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
        --do the Mario
        --swing your arms from side to side
        if mod.nesData.isActive then
            mod.nesData.framesToUpdate = mod.nesData.framesToUpdate + (dt * mod.nesData.fps) / G.SETTINGS.GAMESPEED
            card.ability.extra.mult = mod.nesData.tetrisLines
        else
            mod.resetMario()
        end
    end
end

function jokerInfo.draw(self,card,layer)
    --Withouth love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of
    --the rendering code. We need a clean slate for rendering to canvases.
    if card.area.config.collection and not self.discovered then
        return
    end

    love.graphics.push('all')
    love.graphics.reset()
    if not card.children.center.video then
        setupCanvas(card)
    end
    card.children.center.video:renderTo(function()
        love.graphics.draw(mod.nesData.image,5,5,0,59 / mod.nesData.width, 63 / mod.nesData.height,1,1)
        love.graphics.draw(mod.tetrisCardOverlay)
    end)
    love.graphics.pop()
end

require = oldRequire

return jokerInfo